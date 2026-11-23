{
  k3sVersion = "1.36.6+k3s1";
  k3sCommit = "fa45d6a5ad0c9b8fdf90cf6a2eeeafaccfb60709";
  k3sRepoSha256 = "113829ig3rdfhyw9w1cidg04gx72rwmf38q8fwi8g54a9432xj8z";
  k3sVendorHash = "sha256-RK5BS+OjOfc3yJTHtn08Qp1lrlAaXevFcizi8FqkuqY=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.3";
  k3sRootSha256 = "0w1di4wgcqfnphriq9ln9552z8gmlz5f5lzxipgxqwdzqhqb4fcr";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.3.7-k3s1.36";
  containerdSha256 = "0y1bcf9wij1ps4n98l0ydpdh4lxrdabmcwwkbis6gvp45v1kaar2";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.36.0-k3s1";
  flannelVersion = "v0.28.10";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.11.1-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.13.3-build20261021";
}
