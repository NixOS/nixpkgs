{
  rke2Version = "1.34.7+rke2r1";
  rke2Commit = "6fb975ad761d191a245a4c0215843e8c19423ac9";
  rke2TarballHash = "sha256-2+EVvexT0oco6xI/nAfau4yz9wotynD4ejm6xC8JssQ=";
  rke2VendorHash = "sha256-eX29l/K8UIWkSKIcJBn9Be2zPqxqoWlsmK0xs/bdxOo=";
  k8sImageTag = "v1.34.7-rke2r1-build20260416";
  etcdVersion = "v3.6.7-k3s1-build20260415";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.7-0.20260415182025-e7567db58dd7-build20260416";
  dockerizedVersion = "v1.34.7-rke2r1";
  helmJobVersion = "v0.9.17-build20260422";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
