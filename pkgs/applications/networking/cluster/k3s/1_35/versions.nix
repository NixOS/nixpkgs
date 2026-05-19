{
  k3sVersion = "1.35.4+k3s1";
  k3sCommit = "5dc8fe6894219e2156c2ba82b1bee84cad674694";
  k3sRepoSha256 = "0ilsxhfnn30h0lfajn6awz396g7ygm9n2syzsf09k0g1mv741gib";
  k3sVendorHash = "sha256-PzRBM5cSCF3cGIEdvUrQ4x4PyV7rBpMZVP+tYJDH6oo=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.3-k3s1";
  containerdSha256 = "0fn252icn082822r754i2bqd8rivhvjwkfk031a8g0vvw8rz46vj";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.35.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.9.17-build20260422";
}
