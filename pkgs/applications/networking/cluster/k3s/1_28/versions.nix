{
  k3sVersion = "1.28.11+k3s1";
  k3sCommit = "617b0e84f419e37ba995c6dec06ccfbb24bd649c";
  k3sRepoSha256 = "04pmg0qx1sidpkv72vllmnk82v4fg490gvppp79m3jc931v059w9";
  k3sVendorHash = "sha256-6uCzObYCIETT/aswsHR9hOzUPNZe8GJbLWfNqOKWyag=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1.28";
  containerdSha256 = "0nhhx932j551ran3kkvyp4nmsg5c71mq0g6jrcbs2j4nn7yqdkhm";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
