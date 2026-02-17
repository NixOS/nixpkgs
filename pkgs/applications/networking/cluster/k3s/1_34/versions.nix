{
  k3sVersion = "1.34.3+k3s3";
  k3sCommit = "2975fb0973ca47f54b1aa2a8c3a976a779f52349";
  k3sRepoSha256 = "0bvccp573xihzbnkd3n6xldcxpnlwiz9b5p0fw6sxv69m7jaac2f";
  k3sVendorHash = "sha256-R8QXwXmTKsONsbWaedFNDPdYZ82jaQ/T8S9sllqKPjk=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.0-k3s1";
  k3sCNISha256 = "0naqf3jkxz3rd9ljd40wbm8walgi2bx6d1l9wr6mcvrgj7d5g28c";
  containerdVersion = "2.1.5-k3s1";
  containerdSha256 = "0n0g58d352i8wz0bqn87vgrd7z54j268cbmbp19fz68wmifm7fl8";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.34.0-k3s2";
  flannelVersion = "v0.28.0";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.9.12-build20251215";
}
