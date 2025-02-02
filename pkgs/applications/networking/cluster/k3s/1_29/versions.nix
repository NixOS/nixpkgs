{
  k3sVersion = "1.29.11+k3s1";
  k3sCommit = "666b590a7512c0baab01c93bf81222fa22565c45";
  k3sRepoSha256 = "0w9lldvzkd3rrq0gypqnyjmjr73bxay44q2vfcj4my0ryc3bajf4";
  k3sVendorHash = "sha256-FaOBeUONkeG2CfGUN4VRUzpQl0C6b06kKCnb6ICYHzo=";
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
