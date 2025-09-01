{
  k3sVersion = "1.30.14+k3s2";
  k3sCommit = "071b1ead43641c6803e0b9fce6473baeb12357cf";
  k3sRepoSha256 = "0lldw9kgzpr1073zsr5y4jxmh1c8ah4giyxzb10rfcwx06mglmir";
  k3sVendorHash = "sha256-qEvdBT3noOtKdIdHDJZChowXzQMpVpY/l1ioTJCGVJ4=";
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
