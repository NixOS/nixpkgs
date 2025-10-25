{
  rke2Version = "1.32.7+rke2r1";
  rke2Commit = "43f78039de70d99974d298c344595f45c2c47731";
  rke2TarballHash = "sha256-dHrpGM0bz/URLl9smBVKsKinYH5omGU9QGVy7M0lmQY=";
  rke2VendorHash = "sha256-i7EVtQgPhxxzkV6HfzuMrCo9qvaQpqsVe+Q8mbHC9qA=";
  k8sImageTag = "v1.32.7-rke2r1-build20250716";
  etcdVersion = "v3.5.21-k3s1-build20250612";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.5-rc1.0.20250516182639-8e8f2a4726fd-build20250612";
  dockerizedVersion = "v1.32.7-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
