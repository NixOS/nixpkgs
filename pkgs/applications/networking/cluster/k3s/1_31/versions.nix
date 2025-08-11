{
  k3sVersion = "1.31.11+k3s1";
  k3sCommit = "17cfde1c82427535f0d3b6fe15caef1a0e62e82f";
  k3sRepoSha256 = "17dmk8r1rjv2wv4kfyrsdyb9xp696ckq79lzjkvh89x8g31b6p1h";
  k3sVendorHash = "sha256-ogyFEWnTBYjpz9clO3v5DyO23mHPhUS+JC587kLJ5Ck=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.0.5-k3s2.32";
  containerdSha256 = "1q285ijgxhf4w9xgqqg7yi29mb4jqpifk6bqkjih456qxxkiyk2z";
  criCtlVersion = "1.31.0-k3s2";
}
