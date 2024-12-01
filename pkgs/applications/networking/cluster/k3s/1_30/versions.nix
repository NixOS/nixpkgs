{
  k3sVersion = "1.30.6+k3s1";
  k3sCommit = "1829eaae5250b78e24816a9088b0244c0332b369";
  k3sRepoSha256 = "1p792g2sf6sfwkz9zj7s9zzb27z11s2g3lp0ww2k0srj4yg5llpk";
  k3sVendorHash = "sha256-YYe1jzmYKCPVEZUKXOVufbOU2nSMrplkVXztZTKlZDI=";
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
