{
  k3sVersion = "1.35.10+k3s1";
  k3sCommit = "6d11235c21acae16300c4aaf996155ac7388277e";
  k3sRepoSha256 = "18hvjfmw77wa49asr5shzibyfklizmmbj0wdspfs6drr1j1raai0";
  k3sVendorHash = "sha256-5T/6s2zVL1zFfmSL66YQeKG4aCsR/Kd5M2HFVWCFex0=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.3";
  k3sRootSha256 = "0w1di4wgcqfnphriq9ln9552z8gmlz5f5lzxipgxqwdzqhqb4fcr";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.10-k3s1";
  containerdSha256 = "03dilymayij81zl6il9hibhyfm56xlx0sxdqjy1r1lanyi6p85yc";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.35.0-k3s2";
  flannelVersion = "v0.28.10";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.11.1-k3s2";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.13.3-build20261021";
}
