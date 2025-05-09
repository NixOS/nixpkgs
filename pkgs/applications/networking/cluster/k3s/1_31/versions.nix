{
  k3sVersion = "1.31.8+k3s1";
  k3sCommit = "33429f764d560f617c049e4ebb323c00963419c0";
  k3sRepoSha256 = "0dpp3gi2g4qqi0szz53j9z06bcgkdzh3c64651d8zjjj151rmhwv";
  k3sVendorHash = "sha256-vQQGJOFNO2rCJ/UWxWYgH617DctCmTF6eqH7Yq5T+2Q=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.4-k3s2";
  containerdSha256 = "0v34nh6q0plb50s95gzdkrdfbbch7dps15fmddh5h241yfms8sq6";
  criCtlVersion = "1.31.0-k3s2";
}
