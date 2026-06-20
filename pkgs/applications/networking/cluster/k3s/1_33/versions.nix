{
  k3sVersion = "1.33.12+k3s1";
  k3sCommit = "35e4874312bcfd643320c7f7cb225f7063cb9e4e";
  k3sRepoSha256 = "1md7w6n9iz3nk63rnf4ahs66d2vg3gfc5frksar2iw3kcv99bhmc";
  k3sVendorHash = "sha256-O0HIcCzrKGR8NkMoDfaD1wPbAttHt0kEpVjr/kOLMu8=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.3-k3s1.33";
  containerdSha256 = "1zkbjwnhxxkc9lqk2i9wfi10ywd4rsky3sjs2dzlid91l6xgrwhv";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.33.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2";
  helmJobVersion = "v0.10.0-build20260513";
}
