{
  k3sVersion = "1.28.6+k3s2";
  k3sCommit = "c9f49a3b06cd7ebe793f8cc1dcd0293168e743d9";
  k3sRepoSha256 = "0vz5976q58v9x6g1qz6kz3xksgf8gm1f727ccckmpbyxbhw75zsa";
  k3sVendorHash = "sha256-HG4x3N/F5qCFpLxGrUWPkBHHqY7WBRDWN7DNyAcJwyI=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
