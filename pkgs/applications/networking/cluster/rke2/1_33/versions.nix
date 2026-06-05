{
  rke2Version = "1.33.12+rke2r1";
  rke2Commit = "2cf00d600ee7064fe19efee3e35195ad92c006ef";
  rke2TarballHash = "sha256-CESLU8qyr0MnVmXRKaPZ7CFvBmIqpLAiklBrsuw9W/k=";
  rke2VendorHash = "sha256-I09PTw359mW9b8j/tjbedu7gJ0cp+NPEvmikxJMOufQ=";
  k8sImageTag = "v1.33.12-rke2r1-build20260512";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.11-0.20260415182038-2566e39d309b-build20260416";
  dockerizedVersion = "v1.33.12-rke2r1";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
