{
  k3sVersion = "1.29.1+k3s2";
  k3sCommit = "57482a1c1bb9c67b5f893418a114edca1004258e";
  k3sRepoSha256 = "0pvab3dd6dzgk1zgra4jmdwba5b8xssfjr3mihwq1h0c5bxf1cza";
  k3sVendorHash = "sha256-EkRbdUoYpK7M+Wbc2Cf37bOwdwPB6/xLxULO7Bkpt5c=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.29.0-k3s1";
}
