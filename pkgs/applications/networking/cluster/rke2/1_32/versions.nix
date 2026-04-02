{
  rke2Version = "1.32.13+rke2r1";
  rke2Commit = "a361386c83e8e581c2634a408bc7e4dd44fdcedc";
  rke2TarballHash = "sha256-jEr7wTMRUk0dOO50G0+iIKywVlBM5Et//nbt7R2mu/0=";
  rke2VendorHash = "sha256-rptP0Pb5tgufcXMmtaYaNk/Lyqp1bmlk9upm2amKfno=";
  k8sImageTag = "v1.32.13-rke2r1-build20260227";
  etcdVersion = "v3.5.26-k3s1-build20260227";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.12-0.20260211145907-0dc662e80238-build20260211";
  dockerizedVersion = "v1.32.13-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
