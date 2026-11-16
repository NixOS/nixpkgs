{
  k3sVersion = "1.36.5+k3s1";
  k3sCommit = "3dd98cc58ec34991e7e59b93663eee2e26fc1f65";
  k3sRepoSha256 = "0dqbf4b6whdvwqvmbx71x6nv9mmqld480n2lq45lz860n00hjzsq";
  k3sVendorHash = "sha256-Iihk9iUsbY3hn8G5ERD4wtOMXPEJke0ub2rI6K3tuvI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.3.4-k3s1.36";
  containerdSha256 = "0mlazx89616j90s73953spi4ahcas8w9kb51a7qf02pa9isyz5vi";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.36.0-k3s1";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.13.3-build20260727";
}
