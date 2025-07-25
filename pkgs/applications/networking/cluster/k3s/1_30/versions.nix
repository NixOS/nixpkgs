{
  k3sVersion = "1.30.14+k3s1";
  k3sCommit = "a7f3d379effef5e0979996339172adb4f87d78df";
  k3sRepoSha256 = "0kgsfv9bva440a79xgwwdjvhqswzx91mzgf8qishvlwrrw1w0vcm";
  k3sVendorHash = "sha256-y1UCvafEdFozMlWWd0Yunu4oIkLsHnV4IMTq1RLJ87M=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "1.7.27-k3s1";
  containerdSha256 = "1w6ia9a7qs06l9wh44fpf1v2ckf2lfp9sjzk0bg4fjw5ds9sxws0";
  criCtlVersion = "1.29.0-k3s1";
}
