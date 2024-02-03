{
  k3sVersion = "1.29.1+k3s1";
  k3sCommit = "6d77b7a9204ebe40c53425ce4bc82c1df456e911";
  k3sRepoSha256 = "0x9ahb2b8l1gskrw6nwwylblsi6rv11ivxlrplmcjjg4jxv9xc6m";
  k3sVendorHash = "sha256-jKNew4vSqR2kO6LtG0dn+8bdXg8vOnQ56HJMLsmOKSE=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.29.0-k3s1";
}
