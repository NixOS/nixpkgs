{
  rke2Version = "1.33.11+rke2r1";
  rke2Commit = "9e559b0969f73df7242fd618386ffb475ae2d460";
  rke2TarballHash = "sha256-+OnesNR5rnT/jwANvHGyM9ZLoBm/yvTyDD/idP7ncT0=";
  rke2VendorHash = "sha256-9zXirLuvIR/su5irILDgOI6OqbatSeTrenBLgSZEAqY=";
  k8sImageTag = "v1.33.11-rke2r1-build20260416";
  etcdVersion = "v3.6.7-k3s1-build20260415";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.11-0.20260415182038-2566e39d309b-build20260416";
  dockerizedVersion = "v1.33.11-rke2r1";
  helmJobVersion = "v0.9.17-build20260422";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
