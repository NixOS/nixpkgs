{
  k3sVersion = "1.31.10+k3s1";
  k3sCommit = "c02ce139f6409f455775004d235d98fc9bee849b";
  k3sRepoSha256 = "1ap91j0vwgayis1g7j8rh4dxq4g5fn1kkf1dfa2wg0kxfkcldp0x";
  k3sVendorHash = "sha256-URczHgCfkg2XoX9XNxW7GxPQcfMraLkFCTEbGafyTEI=";
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
