{
  k3sVersion = "1.32.4+k3s1";
  k3sCommit = "6b330558e47a257134434508c851193bb4e9bf9d";
  k3sRepoSha256 = "1ss7w5b5k7hjd9szx7p7cqvdqddb71iddqsf6dxkk9r1g5z7sbs5";
  k3sVendorHash = "sha256-e7uLDjCR/q04HwOHTb1E5gGiwKDN2Hbxmym7qJxfpWU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.4-k3s2";
  containerdSha256 = "0v34nh6q0plb50s95gzdkrdfbbch7dps15fmddh5h241yfms8sq6";
  criCtlVersion = "1.31.0-k3s2";
}
