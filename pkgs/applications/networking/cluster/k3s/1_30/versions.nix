{
  k3sVersion = "1.30.0+k3s1";
  k3sCommit = "14549535f13c63fc239ba055d36d590e68b01503";
  k3sRepoSha256 = "1dph6clzzanlx7dbdzpamnw7gpw98j850my28lcb3zdzhvhsc74b";
  k3sVendorHash = "sha256-YBWiIf8F71ibR7sCiYtmsAcY1MsvkhTD/K45tOHQC5w=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.29.0-k3s1";
}
