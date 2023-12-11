{
  k3sVersion = "1.28.4+k3s2";
  k3sCommit = "6ba6c1b65f9483a5eb3657206ca58c9a7464ad9d";
  k3sRepoSha256 = "0ba04zyw20ica90qyj2laddw7g0i8213bdiy4sgmb4i3hkbw8567";
  k3sVendorHash = "sha256-9a5BGirH4oHNp91ok+jw5b6EljZmtifZTfU6nTFSGKs=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.7-k3s1";
  containerdSha256 = "08dxafbac31s0gx3yaj1d53l0lznpj0hw05kiqx23k8ck303q4xj";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
