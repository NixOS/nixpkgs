{
  rke2Version = "1.33.12+rke2r2";
  rke2Commit = "341f3e620b43d178daccfe5199f9cb752b0c3922";
  rke2TarballHash = "sha256-fjhAeDjX8w3c943wjaOamlR4NXZEIhE68iSIP6co6OQ=";
  rke2VendorHash = "sha256-I09PTw359mW9b8j/tjbedu7gJ0cp+NPEvmikxJMOufQ=";
  k8sImageTag = "v1.33.12-rke2r2-build20260521";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.11-0.20260415182038-2566e39d309b-build20260416";
  dockerizedVersion = "v1.33.12-rke2r2";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
