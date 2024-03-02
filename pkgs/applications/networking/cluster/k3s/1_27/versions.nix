{
  k3sVersion = "1.27.9+k3s1";
  k3sCommit = "2c249a39358bd36438ab53aedef5487d950fd558";
  k3sRepoSha256 = "16zcp1ih34zpz6115ivbcs49n5yikgj8mpiv177jvvb2vakmkgv6";
  k3sVendorHash = "sha256-zvoBN1mErSXovv/xVzjntHyZjVyCfPzsOdlcTSIwKus=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2.27";
  containerdSha256 = "0xjxc5dgh3drk2glvcabd885damjffp9r4cs0cm1zgnrrbhlipra";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
