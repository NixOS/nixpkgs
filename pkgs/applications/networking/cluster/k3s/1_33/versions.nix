{
  k3sVersion = "1.33.0+k3s1";
  k3sCommit = "63ab8e534cdfce2a60f4b016dfedb4f8d74ae8ec";
  k3sRepoSha256 = "1ysfzb4216qk9gjmp2zp103xzjgz8irc7h9m4yp041gkvffa7pyg";
  k3sVendorHash = "sha256-eVMCrOAOCB7saYuxQQUUrmRHT+ZURXESTI6ZRKSDGZs=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.4-k3s4";
  containerdSha256 = "05j5jyjnirks11z2930w4k5ij015hsm4pd2wxgj2531fyiy98azl";
  criCtlVersion = "1.31.0-k3s2";
}
