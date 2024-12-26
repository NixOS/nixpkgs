{
  k3sVersion = "1.29.10+k3s1";
  k3sCommit = "ae4df3117e4860c986f81361a8e5825e6418f9ee";
  k3sRepoSha256 = "17c5y00y7f3zadpqkjpbw9ylscs7m7bqcym7y3ddgsm4cg6bz5g7";
  k3sVendorHash = "sha256-X2Js9DxEmjCQc/w6M5+6NS9y3znutFmH7j95fDETqDI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.22-k3s1";
  containerdSha256 = "031rapiynpm7zlzn42l8z4m125lww2vyspw02irs4q3qb6mpx3px";
  criCtlVersion = "1.29.0-k3s1";
}
