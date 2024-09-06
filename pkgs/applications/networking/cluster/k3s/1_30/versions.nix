{
  k3sVersion = "1.30.4+k3s1";
  k3sCommit = "98262b5dee29fe5ac849a0cef90b5d50292b020b";
  k3sRepoSha256 = "1iwg7j0divbh41dx40kz69qkvscvppqb37dqvxayw3ha1yja4sq6";
  k3sVendorHash = "sha256-EovTZ3DvDqWFR9vxhtjgcZcPXVk1C0PYNCxEV5XA6wg=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.20-k3s1";
  containerdSha256 = "12ihr3z8vcglv5b0v9ris29zkkkdvjbcp3bf7ym71a0xdbg83s8i";
  criCtlVersion = "1.29.0-k3s1";
}
