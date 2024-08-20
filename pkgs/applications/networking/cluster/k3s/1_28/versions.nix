{
  k3sVersion = "1.28.12+k3s1";
  k3sCommit = "4717e2a58e04f0ba3d9f43d574a7eff01dea9146";
  k3sRepoSha256 = "02wywlqqna0dj9cam6q3ykb3p5mi96f6lclrg5yhjky7jdvkffds";
  k3sVendorHash = "sha256-RyUlaGQnfrCm4cB5FRs9IAeF+zn4LzAXmIViU3o30Z4=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1.28";
  containerdSha256 = "0nhhx932j551ran3kkvyp4nmsg5c71mq0g6jrcbs2j4nn7yqdkhm";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
