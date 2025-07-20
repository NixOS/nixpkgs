{
  k3sVersion = "1.33.2+k3s1";
  k3sCommit = "6e38c8b55284c0d68f64a9e603fb645a32ecd232";
  k3sRepoSha256 = "1s2ibbq2ivy1w3dkqlwnipg6cphiji0ax96fagfxgzwyjhxkyvxh";
  k3sVendorHash = "sha256-MLntaqh1uwJ4cfvHW4lJxUzxtlq87DWCfhU4X6aRbxI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.0.5-k3s1";
  containerdSha256 = "1c3hv22zx8y94zwmv5r59bnwgqyhxd10zkinm0jrcvny32ijqdfj";
  criCtlVersion = "1.31.0-k3s2";
}
