{
  k3sVersion = "1.36.3+k3s1";
  k3sCommit = "5aed4d7beddeb3e67120da477c876ac9efd70318";
  k3sRepoSha256 = "0y5lc93f5pdvgm3mmk87mh50z7iway4cz99nskfh1600zfhia2s6";
  k3sVendorHash = "sha256-pxYh1AJVZL8Xx23Nairoi5bSNNSVs+EqJbXF7ISN3wg=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.3.2-k3s2";
  containerdSha256 = "1jzhkh0zg1s2922fkr4r5v1680apafkjqba8ic6br8nc8bk7j4xq";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.36.0-k3s1";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.13.3-build20260727";
}
