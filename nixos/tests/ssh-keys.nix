pkgs:
{ snakeOilPrivateKey = pkgs.writeText "privkey.snakeoil" ''
    -----BEGIN EC PRIVATE KEY-----
    MHcCAQEEIHQf/khLvYrQ8IOika5yqtWvI0oquHlpRLTZiJy5dRJmoAoGCCqGSM49
    AwEHoUQDQgAEKF0DYGbBwbj06tA3fd/+yP44cvmwmHBWXZCKbS+RQlAKvLXMWkpN
    r1lwMyJZoSGgBHoUahoYjTh9/sJL7XLJtA==
    -----END EC PRIVATE KEY-----
  '';

  snakeOilPublicKey = pkgs.lib.concatStrings [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHA"
    "yNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa"
    "9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= snakeoil"
  ];

  snakeOilEd25519PrivateKey = pkgs.writeText "privkey.snakeoil" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACAYBTIWo1J4PkY4/7AhVyPT8xvAUI67tp+yYFFRdSm7+QAAAJC89yCivPcg
    ogAAAAtzc2gtZWQyNTUxOQAAACAYBTIWo1J4PkY4/7AhVyPT8xvAUI67tp+yYFFRdSm7+Q
    AAAEDJmKp3lX6Pz0unTc0QZwrHb8Eyr9fJUopE9d2/+q+eCxgFMhajUng+Rjj/sCFXI9Pz
    G8BQjru2n7JgUVF1Kbv5AAAACnRvbUBvemRlc2sBAgM=
    -----END OPENSSH PRIVATE KEY-----
  '';

  snakeOilEd25519PublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgFMhajUng+Rjj/sCFXI9PzG8BQjru2n7JgUVF1Kbv5 snakeoil";
}
