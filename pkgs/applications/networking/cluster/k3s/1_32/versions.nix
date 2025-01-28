{
  k3sVersion = "1.32.0+k3s1";
  k3sCommit = "cca8facaa33a3ec7897349a8740fd96029590c31";
  k3sRepoSha256 = "0l8mciwv2wr266zxv9zc5wpgf92gqvzg4d08z4g63wbvsi7zflzh";
  k3sVendorHash = "sha256-3hY67A6GbzB2ki5GB7GmmmGG5A4cup17zhkUNiN1chk=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.31.0-k3s2";
}
