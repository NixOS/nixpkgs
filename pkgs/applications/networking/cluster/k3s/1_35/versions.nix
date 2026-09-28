{
  k3sVersion = "1.35.8+k3s1";
  k3sCommit = "e952d68a5a5f8953c4549cf8fb557f3eae417107";
  k3sRepoSha256 = "07kpi9kl8pw4fyba474dap5hiskxays8qa8mf4qz6ai4wqapzg5c";
  k3sVendorHash = "sha256-2u9D2HLhiryOi8bwu5Tbv162WEoRbFfgePW7AeefuG8=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.2";
  k3sRootSha256 = "0yxq2jqqb7flm4rs9dl7fqxba3mmwkmjbc8rx7pgai4qa1lzyigy";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.7-k3s1";
  containerdSha256 = "0zn64g6fzv8knan550ydbkgkaxa8qi2l8dw38w9g3hm8lv43nqyv";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.35.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.13.3-build20260727";
}
