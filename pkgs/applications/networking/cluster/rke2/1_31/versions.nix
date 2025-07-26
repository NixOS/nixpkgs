{
  rke2Version = "1.31.9+rke2r1";
  rke2Commit = "bfd6faa5c0423e3260e2f8b99d59c07b0982a74d";
  rke2TarballHash = "sha256-9XbOAFkmQ2UnADAZ0onu7molUlXxPt+FejbEo9qokOE=";
  rke2VendorHash = "sha256-XkMran1JjgUp6dtvN/XrruMrawPnS5USf+hc5dKeRc0=";
  k8sImageTag = "v1.31.9-rke2r1-build20250515";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.31.2-0.20241016053446-0955fa330f90-build20241016";
  dockerizedVersion = "v1.31.9-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
