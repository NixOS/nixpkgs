{
  rke2Version = "1.37.0+rke2r1";
  rke2Commit = "37af8f9f73a0e95c36295142a63fdcb218cd34e2";
  rke2TarballHash = "sha256-yQJmLf3l5nxM2kgyPFqDML/4XsSAZduLxMF2EjWJWPE=";
  rke2VendorHash = "sha256-Y3Cw7JB2eACxDTrgGTFmpDcdG0FN3ltjopO/Oh8yQgE=";
  k8sImageTag = "v1.37.0-rke2r1-build20260909";
  etcdVersion = "v3.7.1-k3s1-build20260910";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.35.1-0.20260817230842-2a1e2e8cf41b-build20260910";
  dockerizedVersion = "v1.37.0-rke2r1";
  helmJobVersion = "v0.13.3-build20260909";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
