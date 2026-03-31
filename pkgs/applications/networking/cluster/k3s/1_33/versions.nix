{
  k3sVersion = "1.33.10+k3s1";
  k3sCommit = "52978a7f01d46758c472a6f528dcc255c0797578";
  k3sRepoSha256 = "0an56jm4lchwc2czqjs9z6sp88vacj73v06bngz4xz7v24v2ag4z";
  k3sVendorHash = "sha256-w8pwAU0q2zYTP0vBwNjNX0XUvFkISnDOB4549tb35Nc=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.2-k3s1";
  containerdSha256 = "0lqyv4ps1nyjm8fi7znk3r2z3j4ida2h9x1nkzb7c72lz96q1jzs";
  containerdPackage = "github.com/brandond/containerd/v2";
  criCtlVersion = "1.33.0-k3s2";
  flannelVersion = "v0.28.2";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2";
  helmJobVersion = "v0.9.14-build20260309";
}
