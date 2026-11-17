{
  k3sVersion = "1.37.2+k3s1";
  k3sCommit = "f6973cb850e9b245585363d15bde80904ac862fd";
  k3sRepoSha256 = "1rm5s428mnzgwssdnzddgzyhqaivgpchg9z3qbw649a83fqbs7wd";
  k3sVendorHash = "sha256-EQoB6U/pRPJm1RsMo2RdqzeFc2YQ3Lq68b9UDD4shZ4=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.3";
  k3sRootSha256 = "0w1di4wgcqfnphriq9ln9552z8gmlz5f5lzxipgxqwdzqhqb4fcr";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.3.7-k3s1";
  containerdSha256 = "01iwvbnxk4bs53gyhk0w5c9gc8wc856jksa0dsm73iskb5fs8dci";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.37.0-k3s1";
  flannelVersion = "v0.28.10";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.11.1-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.13.3-build20261021";
}
