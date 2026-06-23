{
  rke2Version = "1.35.5+rke2r2";
  rke2Commit = "a779b949d9a7987fc51e7c71c146db4160d0e3bf";
  rke2TarballHash = "sha256-eMqaz7DmIwANpvcQxEA6rJQcLmdBlEFT8Qju+Wr0dTo=";
  rke2VendorHash = "sha256-LV3ISu7bW6kxlKFe0GUqkB9Jte1Ey5DaWm+OKq1/1uY=";
  k8sImageTag = "v1.35.5-rke2r2-build20260521";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.4-0.20260415195656-e51c0636351d-build20260415";
  dockerizedVersion = "v1.35.5-rke2r2";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
