{
  k3sVersion = "1.33.4+k3s1";
  k3sCommit = "148243c49519922720fe1b340008dbce8fb02516";
  k3sRepoSha256 = "1870l3mq5nsh8i82wvwsz7nqiv1xzyqypm66rfmp999s2qlssyaa";
  k3sVendorHash = "sha256-JbnoV8huyOS7Q91QjqTKvPEtkYQxjR10o0d5z25Ycsg=";
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
