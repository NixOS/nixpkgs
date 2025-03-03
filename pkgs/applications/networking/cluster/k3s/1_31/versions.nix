{
  k3sVersion = "1.31.6+k3s1";
  k3sCommit = "6ab750f93f790b02553e4e22f7937e1c58e2b7ea";
  k3sRepoSha256 = "1zblm921w6lfl5mb04z8zn4hqhfn1sjq7q5n4kdfsdvllgdiprfs";
  k3sVendorHash = "sha256-1ExrTDHRJEfndmMDO4xDzwFNZQCJbHYUOHWcXJIwBGo=";
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
