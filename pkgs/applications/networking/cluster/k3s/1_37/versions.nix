{
  k3sVersion = "1.37.0+k3s1";
  k3sCommit = "bb7cf0657bafdfbb4349d1740810442d09c2248a";
  k3sRepoSha256 = "0glzg974w7f0jdaljr9bxw36qv53chii25rjbrvlbzlyzjq19wws";
  k3sVendorHash = "sha256-AObmRWcIyFDy1aTA66LLFYnnUQzpf6+Ts6HQRA3i26A=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.3.4-k3s1";
  containerdSha256 = "18kci7drnlxkn4vk166jijavgwaml1vhlfqirhzljmb4g16ydrah";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.37.0-k3s1";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.13.3-build20260727";
}
