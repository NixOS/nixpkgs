{
  k3sVersion = "1.34.3+k3s1";
  k3sCommit = "48ffa7b6893f21b919b3029d54c9d9838ae426a1";
  k3sRepoSha256 = "1177kzbhp6ihb7dzfdi1a0idgp69y1hwh6wnwvdx1fnivg2gj7aw";
  k3sVendorHash = "sha256-dp8SU24nuy3WmG1Zln/J2nVHnVQmVyN78FBOSxNjbF8=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1";
  containerdSha256 = "0n0g58d352i8wz0bqn87vgrd7z54j268cbmbp19fz68wmifm7fl8";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.34.0-k3s2";
  flannelVersion = "v0.27.4";
  flannelPluginVersion = "v1.8.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.9.12-build20251215";
}
