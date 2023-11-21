{
  k3sVersion = "1.27.7+k3s2";
  k3sCommit = "575bce7689f4be112bd0099362fb8d5f2e39398e";
  k3sRepoSha256 = "1k8hmxdc45pxwkpkq3y1jpx1ybv1h9y4sk7zb09y0487jqqgd15f";
  k3sVendorHash = "sha256-IqnBau4uBIN8ccnoX1P3ud8ZoMR3BjhchLU32tq0YWQ=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.7-k3s1.27";
  containerdSha256 = "1v1hzjcd8ym3nf7bb88z4n8q1g7gawrkp0j82ah80ars40mifhan";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
