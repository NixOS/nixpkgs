{
  k3sVersion = "1.27.8+k3s2";
  k3sCommit = "02fcbd1f57f0bc0ca1dc68f98cfa0e7d3b008225";
  k3sRepoSha256 = "02g741b43s2ss1mdjnrs7fx4bhv9k55k4n350h9qp5jgqg8ldbdi";
  k3sVendorHash = "sha256-mCPr+Y8wiWyW5T/iYH7Y4tz+nrqGyD2IQnIFd0EgdjI=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.7-k3s1.27";
  containerdSha256 = "1v1hzjcd8ym3nf7bb88z4n8q1g7gawrkp0j82ah80ars40mifhan";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
