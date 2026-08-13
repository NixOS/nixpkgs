{
  k3sVersion = "1.35.7+k3s1";
  k3sCommit = "cd43afc7151132bac92feacd3e4d2127ea1e70d0";
  k3sRepoSha256 = "1m9kwz8i1sqjgmc71qknmr87c9g8z7r2wl9440r32lfzxq8a6g1b";
  k3sVendorHash = "sha256-0MVOVrRWZ/xyTaRq5Nw5ogxIGZLArDVA1wiHmiwKqFA=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.5-k3s2";
  containerdSha256 = "1i9vkmf3gg34d9hjq15c00frhqxs9cba03zwg7qqq34gkb4qhjch";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.35.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.13.3-build20260727";
}
