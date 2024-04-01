{
  k3sVersion = "1.29.2+k3s1";
  k3sCommit = "86f102134ed6b1669badd3bfb6420f73e8f015d0";
  k3sRepoSha256 = "0gd35ficik92x4svcg4mlw1v6vms7sfw1asmdahh16li4j27wdz5";
  k3sVendorHash = "sha256-KG795CA3l+iCdJlYMNTQLmv3YqmtM2juacbsmH7B//M=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.29.0-k3s1";
}
