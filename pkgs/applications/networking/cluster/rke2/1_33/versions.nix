{
  rke2Version = "1.33.7+rke2r3";
  rke2Commit = "7e4fd1a82edf497cab91c220144619bbad659cf4";
  rke2TarballHash = "sha256-kyTKacfVD93cwozXkjusR/eshibIyAPEmEyhRiAvppw=";
  rke2VendorHash = "sha256-P6p//+38sM0dobc+Xx0Gd+A01cJsUUE+eblUtc3Cet4=";
  k8sImageTag = "v1.33.7-rke2r3-build20260127";
  etcdVersion = "v3.5.26-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.7-0.20251210094413-291666bcc1a4-build20251210";
  dockerizedVersion = "v1.33.7-rke2r3";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
