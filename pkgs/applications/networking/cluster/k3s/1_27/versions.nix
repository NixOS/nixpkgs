{
  k3sVersion = "1.27.5+k3s1";
  k3sCommit = "8d074ecb5a8765a09eeef6f8be7987055210bc40";
  k3sRepoSha256 = "0bv0r1l97zip9798d8r3ldymmdhlrfw3j9i0nvads1sd1d4az6m6";
  k3sVendorSha256 = "sha256-dFLBa/Sn3GrOPWsTFkP0H2HASE8XB99Orxx5K7nnNio=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.3-k3s1";
  containerdSha256 = "03352jn1igsqi23sll06mdsvdbkfhrscqa2ackwczx1a3innxv9r";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
