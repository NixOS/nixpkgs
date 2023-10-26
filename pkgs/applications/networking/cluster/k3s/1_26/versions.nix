{
  k3sVersion = "1.26.9+k3s1";
  k3sCommit = "4e217286a7ea41b82f1b67ab851d444ecf9a0f9b";
  k3sRepoSha256 = "1rf2gzf3ilcd1gc6d4k1w6cficr70x8lwzcq81njpz72dr6883z3";
  k3sVendorHash = "sha256-heCQNRaa0qFNkL69KEiIH2qEg+pukgS+fLOSWcwFddA=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.6-k3s1.26";
  containerdSha256 = "1bj7nggfmkrrgm5yk08p665z1mw1y376k4g3vjbkqldfglzpx7sq";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
