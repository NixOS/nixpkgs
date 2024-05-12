{
  k3sVersion = "1.29.4+k3s1";
  k3sCommit = "94e29e2ef5d79904f730e2024c8d1682b901b2d5";
  k3sRepoSha256 = "0kkhd2fnlmjanzvwgdclmbg6azw3r1a2lj5207716pavxmb9ld7y";
  k3sVendorHash = "sha256-wOX+ktGPFYUKLZBK/bQhWWG+SnRCkNYnk3Tz8wpMo5A=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.29.0-k3s1";
}
