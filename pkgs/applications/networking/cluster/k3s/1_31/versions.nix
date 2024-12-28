{
  k3sVersion = "1.31.4+k3s1";
  k3sCommit = "a562d090b05cf8d55b6a8b57556787c24c8ce21a";
  k3sRepoSha256 = "1kgw3jnaqh8lnbljgdvyl14vdlyvy8gw2jsqqj3qv1kv1m3qqsjw";
  k3sVendorHash = "sha256-OtIQ3pmN4V3qJODF5/fSespbKvucvzi4ykdmGkRVlf4=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.31.0-k3s2";
}
