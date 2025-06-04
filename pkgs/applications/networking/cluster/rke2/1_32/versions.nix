{
  rke2Version = "1.32.5+rke2r1";
  rke2Commit = "96e5d2054ec1ecbe9799514eddbeab58579b93e5";
  rke2TarballHash = "sha256-GoY1gG5O3F5o6tQFk9RyNhInQwgKQBcyyM3tMZUw2As=";
  rke2VendorHash = "sha256-d8YTRyFse6ZYLeX2PxL08j4ZNZEh70Czq/Elt6ER234=";
  k8sImageTag = "v1.32.5-rke2r1-build20250515";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.0-rc3.0.20241220224140-68fbd1a6b543-build20250101";
  dockerizedVersion = "v1.32.5-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
