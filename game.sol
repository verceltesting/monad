// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DinoGame {
    struct PlayerScore {
        uint256 score;
        uint256 timestamp;
    }

    mapping(address => PlayerScore[]) public scoreHistory;
    mapping(address => uint256) public latestScore;

    address[] public players;

    function submitScore(uint256 score) public {
        scoreHistory[msg.sender].push(PlayerScore(score, block.timestamp));
        latestScore[msg.sender] = score;

        bool exists = false;
        for (uint i = 0; i < players.length; i++) {
            if (players[i] == msg.sender) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            players.push(msg.sender);
        }
    }

    function getScoreHistory(address player) public view returns (PlayerScore[] memory) {
        return scoreHistory[player];
    }

    function getTopPlayers() public view returns (address[10] memory topWallets, uint256[10] memory topScores) {
        uint256[10] memory scores;
        address[10] memory wallets;

        for (uint i = 0; i < players.length; i++) {
            uint256 score = latestScore[players[i]];
            for (uint j = 0; j < 10; j++) {
                if (score > scores[j]) {
                    // Shift down
                    for (uint k = 9; k > j; k--) {
                        scores[k] = scores[k - 1];
                        wallets[k] = wallets[k - 1];
                    }
                    scores[j] = score;
                    wallets[j] = players[i];
                    break;
                }
            }
        }
        return (wallets, scores);
    }
}
