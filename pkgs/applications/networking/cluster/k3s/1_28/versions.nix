{
  k3sVersion = "1.28.11+k3s2";
  k3sCommit = "d076d9a78cb835279a04f12c816ff4404884862e";
  k3sRepoSha256 = "1k1k3qmxc7n2h2i0g52ad4gnpq0qrvxnl7p2y0g9dss1ancgqwsd";
  k3sVendorHash = "sha256-tzcMcsTmY8lG+9EyYkzYJm1YU/8tGpxpH7oZ4Jl/yNU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1.28";
  containerdSha256 = "0nhhx932j551ran3kkvyp4nmsg5c71mq0g6jrcbs2j4nn7yqdkhm";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
