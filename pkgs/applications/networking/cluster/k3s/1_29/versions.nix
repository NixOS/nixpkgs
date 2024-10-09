{
  k3sVersion = "1.29.9+k3s1";
  k3sCommit = "e92d3b3ba7a4810e82e38a3d5c6091a3e18caad5";
  k3sRepoSha256 = "1i4881nv41dpvxmh20qy121d45431xbhkzlywx1rfwqla8wq6bwh";
  k3sVendorHash = "sha256-JeX9SJw6U1/FMbv9fVQeQvAZKq+Z99ZrLC2bAy1vUkA=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.21-k3s2";
  containerdSha256 = "0kp93fhmw2kiy46hw3ag05z8xwhw7kqp4wcbhsxshsdf0929g539";
  criCtlVersion = "1.29.0-k3s1";
}
