{
  rke2Version = "1.34.8+rke2r2";
  rke2Commit = "b227fefe1936a550450ce3b6248c559fa58b5cd3";
  rke2TarballHash = "sha256-Ojc4PhsEYJBhgj+r+XEcdFEjZIlJCCVNC+w7mZWY2hA=";
  rke2VendorHash = "sha256-752RlnL+7reFk4G/X8kgHdad71fatY+Ss714MbJDvg8=";
  k8sImageTag = "v1.34.8-rke2r2-build20260521";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.7-0.20260415182025-e7567db58dd7-build20260416";
  dockerizedVersion = "v1.34.8-rke2r2";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
