{
  rke2Version = "1.35.5+rke2r1";
  rke2Commit = "e28e7c1a0404f1e9bf36e8b7222d64aec6b7a004";
  rke2TarballHash = "sha256-t++HKNbR4WGzZiR6rVMke7lbixXA8H5ibovfitwPuXE=";
  rke2VendorHash = "sha256-LV3ISu7bW6kxlKFe0GUqkB9Jte1Ey5DaWm+OKq1/1uY=";
  k8sImageTag = "v1.35.5-rke2r1-build20260512";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.4-0.20260415195656-e51c0636351d-build20260415";
  dockerizedVersion = "v1.35.5-rke2r1";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
