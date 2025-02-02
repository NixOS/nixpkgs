{
  k3sVersion = "1.28.10+k3s1";
  k3sCommit = "a4c5612ea3dd202135e7c691c534c671a7d43690";
  k3sRepoSha256 = "00r06kc98nvbmaai8m2pbqsl0v6y3kbc3rz3l7lb9wy4qhiyxrww";
  k3sVendorHash = "sha256-8PbpjPVX+Yimhwbydu9YOTIMRTf/iLG21Ee/QMowp5Y=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
