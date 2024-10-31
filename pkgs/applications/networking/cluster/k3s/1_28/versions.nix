{
  k3sVersion = "1.28.14+k3s1";
  k3sCommit = "3ef2bdb1e5ba667b735a65cbfa43229fd49230ef";
  k3sRepoSha256 = "146xxpldp7bffn8sigfp9xjj8hw793ybp1xrfyb9s0bd85yxiw4x";
  k3sVendorHash = "sha256-Y5s5lPP2bVGPHQPma3DJYYP91I3HQQoi+KbjEZpTr6w=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.21-k3s2.28";
  containerdSha256 = "00gdmd617mxf246m3mfz8if8snaciib4zdb7fm12mdhf52w031a6";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
