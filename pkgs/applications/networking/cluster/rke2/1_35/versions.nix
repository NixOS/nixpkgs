{
  rke2Version = "1.35.4+rke2r1";
  rke2Commit = "5dc4f4390d27d77b17b6506d8b22aed72aa4fbe6";
  rke2TarballHash = "sha256-VWhml35keKn9Fhj/SeySpusi8yzz9dwgPC2rfABXPrk=";
  rke2VendorHash = "sha256-uaPjOFSwCxMWH/LD8tvE0VttPWJ9agMYm4E2mWiuYfw=";
  k8sImageTag = "v1.35.4-rke2r1-build20260416";
  etcdVersion = "v3.6.7-k3s1-build20260415";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.4-0.20260415195656-e51c0636351d-build20260415";
  dockerizedVersion = "v1.35.4-rke2r1";
  helmJobVersion = "v0.9.17-build20260422";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
