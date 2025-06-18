{
  rke2Version = "1.33.1+rke2r1";
  rke2Commit = "01d605e84711a636d407f6a87060425373b9f09e";
  rke2TarballHash = "sha256-DrNNkvKIfrXKMO75w+DKe0dB9iOicVBnsKcSaYOAl0E=";
  rke2VendorHash = "sha256-nzWU9B+/r+1RydZGCm6qYtf+z29sGnUjg13PHCyv7h0=";
  k8sImageTag = "v1.33.1-rke2r1-build20250515";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.0-rc1.0.20250430074337-dc03cb4b3faa-build20250430";
  dockerizedVersion = "v1.33.1-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
