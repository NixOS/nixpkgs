{
  k3sVersion = "1.30.7+k3s1";
  k3sCommit = "00f901803ada2af4adb0439804f98b6fb6379992";
  k3sRepoSha256 = "0jvbd4g1kisyjs2hrz4aqwrg08b13pvdf10dyyavvw1bmzki26ih";
  k3sVendorHash = "sha256-3kLD2oyeo1cC0qRD48sFbsARuD034wilcNQpGRa65aQ=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.29.0-k3s1";
}
