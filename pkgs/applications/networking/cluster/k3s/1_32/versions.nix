{
  k3sVersion = "1.32.8+k3s1";
  k3sCommit = "fe896f7e7cf8be1cfffe7151c6860deb08e2a005";
  k3sRepoSha256 = "1knj7jzxb70zvqjn7pbjz78cm06w0402id5frib94y0i4rsmqd6g";
  k3sVendorHash = "sha256-MbXTUvdnoLFVGYKEGBYWNkuL2Es0Io4q2E5qaUptwRQ=";
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
