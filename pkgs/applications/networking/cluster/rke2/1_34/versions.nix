{
  rke2Version = "1.34.8+rke2r1";
  rke2Commit = "4fdfd151975bbc58c8d392620db8eea72fea2abc";
  rke2TarballHash = "sha256-n98pZhWARQMyKj8G9+ymmMZyzoiGo+KPMr0F5KDphqU=";
  rke2VendorHash = "sha256-752RlnL+7reFk4G/X8kgHdad71fatY+Ss714MbJDvg8=";
  k8sImageTag = "v1.34.8-rke2r1-build20260512";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.7-0.20260415182025-e7567db58dd7-build20260416";
  dockerizedVersion = "v1.34.8-rke2r1";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
