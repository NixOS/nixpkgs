{
  k3sVersion = "1.33.9+k3s1";
  k3sCommit = "f93a18d13d956f6c7f1cc6101e6048766df09ebb";
  k3sRepoSha256 = "006g6spjfqnz5w57hls4iy1b84r9y6i6h0ybfprhsphdk5fblvkn";
  k3sVendorHash = "sha256-PKEPdSdljMOFxwh/xbfSHziRPxMgfvNGK3fQqiNC0UI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.0-k3s1";
  k3sCNISha256 = "0naqf3jkxz3rd9ljd40wbm8walgi2bx6d1l9wr6mcvrgj7d5g28c";
  containerdVersion = "2.1.5-k3s1.33";
  containerdSha256 = "15iw6px3710rlsx7j933i07qd4a2r7caagfjbhhfcp33m9k19v7h";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.33.0-k3s2";
  flannelVersion = "v0.28.0";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2";
  helmJobVersion = "v0.9.14-build20260210";
}
