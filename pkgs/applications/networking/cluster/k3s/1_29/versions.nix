{
  k3sVersion = "1.29.14+k3s1";
  k3sCommit = "6873bccf9cb3221bd422f0f88c2cde6f9855ef70";
  k3sRepoSha256 = "03f9k1psrdkhz8371q37xncdhshz961sqskw2w7w23pgngxfdqsl";
  k3sVendorHash = "sha256-RvDtV4n4qqi2KajmhjEELi6CFeJ1H+Fr4fgdrdoPVeA=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.29.0-k3s1";
}
