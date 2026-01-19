{
  k3sVersion = "1.33.7+k3s1";
  k3sCommit = "0b396d3f7f26e0c2ae5b6a114383830f533938c2";
  k3sRepoSha256 = "0jkvm7c333zazabsxrjl6wkdsni1m5g5gamriyyf53lly9935wsf";
  k3sVendorHash = "sha256-HpgcO/mUo64mkH38sAURnLOmXdXmHh3o6iDKtQeUt/E=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1.33";
  containerdSha256 = "15iw6px3710rlsx7j933i07qd4a2r7caagfjbhhfcp33m9k19v7h";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.33.0-k3s2";
  flannelVersion = "v0.27.4";
  flannelPluginVersion = "v1.8.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2";
  helmJobVersion = "v0.9.12-build20251215";
}
