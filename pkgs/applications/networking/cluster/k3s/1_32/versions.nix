{
  k3sVersion = "1.32.5+k3s1";
  k3sCommit = "8e8f2a4726fdb4ca628eb62b2a526b64d0e6a763";
  k3sRepoSha256 = "02qsw00f0k0kv93xws96np3fj3rdynnhjhk41a58kic1mnbgm8ss";
  k3sVendorHash = "sha256-BZs3tgUtcLw1mqaAyOCwg6bhmeQbUGCE9wsbPSG61t4=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.5-k3s1.32";
  containerdSha256 = "1la7ygx5caqfqk025wyrxmhjb0xbpkzwnxv52338p33g68sb3yb0";
  criCtlVersion = "1.31.0-k3s2";
}
