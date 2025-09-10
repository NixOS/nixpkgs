{
  k3sVersion = "1.31.12+k3s1";
  k3sCommit = "2b53c7e4c81742fbb2b0e7e90e3bb907d1fe0e24";
  k3sRepoSha256 = "07pi1vjpm01q2riq0dic6p27nqj4wzwwzllxgmr7gfim1xx643gd";
  k3sVendorHash = "sha256-osqhQJq+Qst3LpYdhXkAY6Pxay381PmoxD5Ji/ZV86Q=";
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
