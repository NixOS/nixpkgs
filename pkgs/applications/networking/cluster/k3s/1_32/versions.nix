{
  k3sVersion = "1.32.2+k3s1";
  k3sCommit = "381620efbd1933b96f9cfaf37f46dfb5c58403a8";
  k3sRepoSha256 = "0xaw2b6lawg9jdsli333wwgq7irpig7a7p3kb7khqyhgb8y292qr";
  k3sVendorHash = "sha256-PB3KWvCqi7KxeiKrP9VHYpE4xdXhVSDQoCuwYQe4RoQ=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.31.0-k3s2";
}
