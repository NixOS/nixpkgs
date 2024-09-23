{
  k3sVersion = "1.31.0+k3s1";
  k3sCommit = "34be6d96d17d8d65fda86272b62b752cb0e9c45e";
  k3sRepoSha256 = "16yzsx56jmca07jdnzjvy4pcfrvvibv987l1mzdaws1vkm3xqfnw";
  k3sVendorHash = "sha256-1uYlvGkW6n4aiUVX/2OjppczdobY/fk1ZaK6j3AEwvM=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.20-k3s1";
  containerdSha256 = "12ihr3z8vcglv5b0v9ris29zkkkdvjbcp3bf7ym71a0xdbg83s8i";
  criCtlVersion = "1.31.0-k3s2";
}
