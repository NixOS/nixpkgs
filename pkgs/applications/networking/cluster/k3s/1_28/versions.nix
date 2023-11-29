{
  k3sVersion = "1.28.3+k3s2";
  k3sCommit = "bbafb86e91ae3682a1811119d136203957df9061";
  k3sRepoSha256 = "0vbkz8p6bf32lg4n3p5prbghi0wm30nsj6wfmyqacxzzmllqynyk";
  k3sVendorHash = "sha256-DHj2rFc/ZX22uvr3HuZr0EvM2gbZSndPtNa5FYqv08o=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.7-k3s1";
  containerdSha256 = "08dxafbac31s0gx3yaj1d53l0lznpj0hw05kiqx23k8ck303q4xj";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
