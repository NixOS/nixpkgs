{
  k3sVersion = "1.33.3+k3s1";
  k3sCommit = "236cbf257332b293f444abe6f24d699ff628173e";
  k3sRepoSha256 = "163brwnz4af1rjv5pcghlzjnwr27b087y73bv6pri0fyqd3mwiim";
  k3sVendorHash = "sha256-rU+rpExb9LVIROPj3MN924r7Hk8sK/5P8JSssOoIWTU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.0.5-k3s2";
  containerdSha256 = "0011p1905jsswz1zqzkylzjfvi50mc60ifgjnjxwnjrk2rnwbmbz";
  criCtlVersion = "1.31.0-k3s2";
}
