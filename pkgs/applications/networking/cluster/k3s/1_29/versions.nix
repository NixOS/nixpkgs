{
  k3sVersion = "1.29.5+k3s1";
  k3sCommit = "4e53a32306759581f4ed938bcd18b6fa20b83230";
  k3sRepoSha256 = "169hzl23chs4qblicmqj3j10jg1xdq8s9717bd3pzx7wzz9s9mqw";
  k3sVendorHash = "sha256-QreiB4JMtfBjHlkAyflQAW2rnfgay62UD6emx8TgUpM=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.29.0-k3s1";
}
