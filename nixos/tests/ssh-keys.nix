pkgs: {
  # This key is used in integration tests
  # This is NOT a security issue
  # It uses the test key defined in RFC 9500
  # https://datatracker.ietf.org/doc/rfc9500/
  snakeOilPrivateKey = pkgs.writeText "privkey.snakeoil" ''
    -----BEGIN EC PRIVATE KEY-----
    MHcCAQEEIObLW92AqkWunJXowVR2Z5/+yVPBaFHnEedDk5WJxk/BoAoGCCqGSM49
    AwEHoUQDQgAEQiVI+I+3gv+17KN0RFLHKh5Vj71vc75eSOkyMsxFxbFsTNEMTLjV
    uKFxOelIgsiZJXKZNCX0FBmrfpCkKklCcg==
    -----END EC PRIVATE KEY-----
  '';

  snakeOilPublicKey = pkgs.lib.concatStrings [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHA"
    "yNTYAAABBBEIlSPiPt4L/teyjdERSxyoeVY+9b3O+XkjpMjLMRcWxbEzRDEy41b"
    "ihcTnpSILImSVymTQl9BQZq36QpCpJQnI= snakeoil"
  ];

  # This key is used in integration tests
  # This is NOT a security issue
  # It uses the same key than the one used in OpenSSH fuzz tests
  # https://github.com/openssh/openssh-portable/blob/V_9_9_P2/regress/misc/fuzz-harness/fixed-keys.h#L76-L85
  snakeOilEd25519PrivateKey = pkgs.writeText "privkey.snakeoil" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACAz0F5hFTFS5nhUcmnyjFVoDw5L/P7kQU8JnBA2rWczAwAAAIhWlP99VpT/
    fQAAAAtzc2gtZWQyNTUxOQAAACAz0F5hFTFS5nhUcmnyjFVoDw5L/P7kQU8JnBA2rWczAw
    AAAEDE1rlcMC0s0X3TKVZAOVavZOywwkXw8tO5dLObxaCMEDPQXmEVMVLmeFRyafKMVWgP
    Dkv8/uRBTwmcEDatZzMDAAAAAAECAwQF
    -----END OPENSSH PRIVATE KEY-----
  '';

  snakeOilEd25519PublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPQXmEVMVLmeFRyafKMVWgPDkv8/uRBTwmcEDatZzMD snakeoil";
}
