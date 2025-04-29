{
  k3sVersion = "1.31.7+k3s1";
  k3sCommit = "e050ca66d129762a00599628e6f55cfdfab3a7ba";
  k3sRepoSha256 = "1q531x745ypc08wp43yf0mh0r90gpi6r8bqbmgpvx0nvv9gwn8sb";
  k3sVendorHash = "sha256-WQPXRwW50/6e1MPnuQCAICROVlrMfARUdHJAgJ7UwQQ=";
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
