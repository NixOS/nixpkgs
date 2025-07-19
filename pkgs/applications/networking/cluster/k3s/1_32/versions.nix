{
  k3sVersion = "1.32.6+k3s1";
  k3sCommit = "eb603acd1530edcaf79a4a8ed3da54e9e03d9967";
  k3sRepoSha256 = "05py458rdrys1hkw8rg62c98lnwjij5zby8n2zkl1kbfqy12adln";
  k3sVendorHash = "sha256-K8vlX8rucbAOCxHbgrWHsMBWiRc/98IJVCYS8UD+ZsI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.0.5-k3s1.32";
  containerdSha256 = "1la7ygx5caqfqk025wyrxmhjb0xbpkzwnxv52338p33g68sb3yb0";
  criCtlVersion = "1.31.0-k3s2";
}
