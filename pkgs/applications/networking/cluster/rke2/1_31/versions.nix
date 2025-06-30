{
  rke2Version = "1.31.7+rke2r1";
  rke2Commit = "7b18bda1c5ec1e110cec206f9163f6aba3a2154d";
  rke2TarballHash = "sha256-u7U5eGLTrm1mxatl3v4iCBzw/Rin8wlndSs/OKLWtiw=";
  rke2VendorHash = "sha256-UiFpAZHic2GVvdW4RDJxH2j5N2x8ec43YFfvBDR4fyM=";
  k8sImageTag = "v1.31.7-rke2r1-build20250312";
  etcdVersion = "v3.5.19-k3s1-build20250306";
  pauseVersion = "3.6";
  ccmVersion = "v1.31.2-0.20241016053446-0955fa330f90-build20241016";
  dockerizedVersion = "v1.31.7-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
