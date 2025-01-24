{
  k3sVersion = "1.31.2+k3s1";
  k3sCommit = "6da204241bfd40220cb1af4cde35609e0c58df72";
  k3sRepoSha256 = "0n0sfvxnkz8d9prswmqd6paqisis05l0494znjy2y30418ql580x";
  k3sVendorHash = "sha256-SYIg/lYwIY/e0FQt59Ki4ROzhZ5HfJ03Hd0XE2LIIyc=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.22-k3s1";
  containerdSha256 = "031rapiynpm7zlzn42l8z4m125lww2vyspw02irs4q3qb6mpx3px";
  criCtlVersion = "1.31.0-k3s2";
}
