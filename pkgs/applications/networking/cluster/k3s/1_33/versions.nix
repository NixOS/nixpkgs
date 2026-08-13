{
  k3sVersion = "1.33.13+k3s2";
  k3sCommit = "875e930d812e17f955cfb3a4817ad33cce3c6822";
  k3sRepoSha256 = "1hk3z4s2hhzdha894aai4jpl8nc5mkqb2sf7hywi8b11h8ckhv8n";
  k3sVendorHash = "sha256-jsGm6y94Kqd4SIDy00A5QpBylHIuTuirEbChpEKo2R8=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.5-k3s1.33";
  containerdSha256 = "1al4zsyh3pz379ia0awhrlz7nyl2abyy0ayw0gl4gr6xjp7jsp1s";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.33.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2";
  helmJobVersion = "v0.13.3-build20260727";
}
