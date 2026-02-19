{
  k3sVersion = "1.32.12+k3s1";
  k3sCommit = "0dc662e80238b7b70d24ad9025a6b64292d14955";
  k3sRepoSha256 = "1pmdbzxp968hxya590qhf4sz3gx6yzpwhcg24hkfsxbm9bclrr0g";
  k3sVendorHash = "sha256-T5GGzudpTTMb2SBC6+spCo7Q/IOr6LfiWb/oWOcCOv8=";
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
  helmJobVersion = "v0.9.14-build20260210";
}
