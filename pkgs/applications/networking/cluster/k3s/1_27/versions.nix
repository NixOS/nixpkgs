{
  k3sVersion = "1.27.2+k3s1";
  k3sCommit = "213d7ad499e166290872f51c63d8eaa2f1fe78b3";
  k3sRepoSha256 = "0qjkrhmjf4fyclnpyhb059dzxghpzshrs5a5z1vc83mrz1zg6vbq";
  k3sVendorSha256 = "sha256-ZSfQIBS8KsNkYPUH2er6iL3A02SIJwXZ5YLd3NYFl8E=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.2.0-k3s1";
  k3sCNISha256 = "0hzcap4vbl94zsiqc66dlwjgql50gw5g6f0adag0p8yqwcy6vaw2";
  containerdVersion = "1.7.1-k3s1";
  containerdSha256 = "00k7nkclfxwbzcgnn8s7rkrxyn0zpk57nyy18icf23wsj352gfrn";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
