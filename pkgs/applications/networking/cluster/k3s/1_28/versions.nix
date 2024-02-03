{
  k3sVersion = "1.28.5+k3s1";
  k3sCommit = "5b2d1271a6a00a8d71981cc968bc0f822620b9d8";
  k3sRepoSha256 = "0bxgzcv83d6kg8knsxrfzpscihw8wj3i7knlm23zzw4n98p4s29y";
  k3sVendorHash = "sha256-iBw2lHDAi3wIxaK9LX6tzV7DtNllq6kDLJBH3kVqfqQ=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
