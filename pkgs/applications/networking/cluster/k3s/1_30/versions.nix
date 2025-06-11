{
  k3sVersion = "1.30.13+k3s1";
  k3sCommit = "e77f78ee94664d4d5ac34e2c4b8d438dac52c088";
  k3sRepoSha256 = "0hy9pn9cdxixllj8zm4jq65jlrvihiysvhdmkxjgn82n3snhwrgq";
  k3sVendorHash = "sha256-2q9gWVCe3GhAF9YDMX4B9djz5/DliRHingJbXmTwmGE=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.27-k3s1";
  containerdSha256 = "1w6ia9a7qs06l9wh44fpf1v2ckf2lfp9sjzk0bg4fjw5ds9sxws0";
  criCtlVersion = "1.29.0-k3s1";
}
