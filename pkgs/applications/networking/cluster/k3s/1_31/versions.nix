{
  k3sVersion = "1.31.1+k3s1";
  k3sCommit = "452dbbc14c747a0070fdf007ef2239a6e5d8d934";
  k3sRepoSha256 = "012j78bxhmjq7d0z0yzxzbvlhgzx9qi254cpk6s6mi3k60ay6bx2";
  k3sVendorHash = "sha256-CnfnyqrBQ9W1G6NORGSA5jB75Dvd1Hgu+KVITYrb6Mc=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.21-k3s2";
  containerdSha256 = "0kp93fhmw2kiy46hw3ag05z8xwhw7kqp4wcbhsxshsdf0929g539";
  criCtlVersion = "1.31.0-k3s2";
}
