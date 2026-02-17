{
  k3sVersion = "1.32.11+k3s3";
  k3sCommit = "c9aa1d2889a003715698542826c2af94160ac2e5";
  k3sRepoSha256 = "0fi634dnsghjwnp07h6jhknccqlr9n5g3l34sipc41vvfmn4b0k8";
  k3sVendorHash = "sha256-qbmqzsd8oMQSFCh7HvjDiYds5gLEIGjjcv4EJbgxfJI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.0-k3s1";
  k3sCNISha256 = "0naqf3jkxz3rd9ljd40wbm8walgi2bx6d1l9wr6mcvrgj7d5g28c";
  containerdVersion = "2.1.5-k3s1.32";
  containerdSha256 = "1fzld9q0ycfg9b3054qg70mif1p6i7xqikcbabrmxapk81fy83kn";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.31.0-k3s2";
  flannelVersion = "v0.28.0";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2.32";
  helmJobVersion = "v0.9.12-build20251215";
}
