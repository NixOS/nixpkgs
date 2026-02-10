{
  rke2Version = "1.34.3+rke2r3";
  rke2Commit = "7598946e0086a9131564ccbb3c142b3fa54516ad";
  rke2TarballHash = "sha256-qPpEcuW56RnOxnODAfaX/dVEW83axhVAEwiuBPg1wwU=";
  rke2VendorHash = "sha256-RXvIbt98LuvH0HWKS0DYkrSxJYbb+XNBs+8Xr6EVwu4=";
  k8sImageTag = "v1.34.3-rke2r3-build20260127";
  etcdVersion = "v3.6.7-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.3-0.20251210094406-1ff6ebef7028-build20251210";
  dockerizedVersion = "v1.34.3-rke2r3";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
