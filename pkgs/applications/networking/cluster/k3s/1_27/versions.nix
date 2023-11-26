{
  k3sVersion = "1.27.6+k3s1";
  k3sCommit = "bd04941a294793ec92e8703d5e5da14107902e88";
  k3sRepoSha256 = "04chr8gp0yprihigy1yzhvi2baby053fav384gq0sjq6bkp3fzd8";
  k3sVendorHash = "sha256-LH9OsBK0Pq/NGEHprbIgYKQsslYdR3i4LYVvo5P0K+8=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.6-k3s1.27";
  containerdSha256 = "1kzjqw56pcdpsqdkw2k5a3pnpf8n93dh4jc2yybgqz3nyj4fw0a8";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
