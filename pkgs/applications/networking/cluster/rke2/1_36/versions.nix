{
  rke2Version = "1.36.6+rke2r1";
  rke2Commit = "5ee7cd3b0e66d839e5a2dcdca7a5f2020c51ff3c";
  rke2TarballHash = "sha256-KMMYsNBUj61RFslPEo5GfZs5hOhu2Kl6NRbGiBWDpEU=";
  rke2VendorHash = "sha256-Uq394zVKm/6uXy3fCx8iOYHqDiwnBhFlj/DeI7TRjjk=";
  k8sImageTag = "v1.36.6-rke2r1-build20261029";
  etcdVersion = "v3.6.14-k3s3-build20261020";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.36.6-0.20261016153003-c2fdd7c56c2c-build20261021";
  dockerizedVersion = "v1.36.6-rke2r1";
  helmJobVersion = "v0.13.3-build20261021";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
