{
  k3sVersion = "1.29.0+k3s1";
  k3sCommit = "3190a5faa28d7a0d428c756d67adcab7eb11e6a5";
  k3sRepoSha256 = "1g75a7kz9nnv0vagzhggkw0zqigykimdwsmibgssa8vyjpg7idda";
  k3sVendorHash = "sha256-iHmPVjYR/ZLH9UZ5yNEApyuGQsEwtxVbQw7Pu7WrpaQ=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.29.0-k3s1";
}
