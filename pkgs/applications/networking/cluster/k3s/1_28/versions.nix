{
  k3sVersion = "1.28.7+k3s1";
  k3sCommit = "051b14b248655896fdfd7ba6c93db6182cde7431";
  k3sRepoSha256 = "1136h9xwg1p26lh3m63a4c55qsahla0d0xvlr09qqbhqiyv7fn0b";
  k3sVendorHash = "sha256-FzalTtDleFIN12lvn0k7+nWchr6y/Ztcxs0bs2E4UO0=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
