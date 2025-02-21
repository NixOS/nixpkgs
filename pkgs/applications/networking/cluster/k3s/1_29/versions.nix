{
  k3sVersion = "1.29.13+k3s1";
  k3sCommit = "d70d0589c278a77b818c28e6287ab1f95cfce436";
  k3sRepoSha256 = "148cc066gcbzjqcnp92gfhmjifzgm3p641l5zv6gyw4zhk9lyq22";
  k3sVendorHash = "sha256-EiaqK20lxa1QcAv6bdTBmuQ/1nNK9t+C09+cvznrtYk=";
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
