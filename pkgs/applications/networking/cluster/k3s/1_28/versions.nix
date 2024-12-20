{
  k3sVersion = "1.28.15+k3s1";
  k3sCommit = "869dd4d62626f5ba4afe3a923d77b2047c565a43";
  k3sRepoSha256 = "1nijdii01004v2cgpaw0xnzyrljd4iw00wca1lg6szhqmj28gcfv";
  k3sVendorHash = "sha256-zWBMZrpRJzzc4yAIWAnWnmVE7qr7bscJjHrHdDD0Ilg=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.22-k3s1.28";
  containerdSha256 = "0jpq03n5q8aydw4y14w9fl4fqixpdcw42gwvmsp3z3qplbvwkfkl";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
