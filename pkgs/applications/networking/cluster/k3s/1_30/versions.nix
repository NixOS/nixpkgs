{
  k3sVersion = "1.30.9+k3s1";
  k3sCommit = "18c072e5952c0c1b76083d80c2c9a85c833a8dbd";
  k3sRepoSha256 = "0bsh94ns0dkw9vfvvx3max2xlcaw7gzyzbsmlnal1c2xrlcxvg2h";
  k3sVendorHash = "sha256-bif1TiePDi6cyDB+2vDvqPdAKQomEzle9xXhEfzRcsY=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.29.0-k3s1";
}
