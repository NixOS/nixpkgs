{
  rke2Version = "1.31.11+rke2r1";
  rke2Commit = "48500b495b74b976f07ebd07a643e40e6c89f355";
  rke2TarballHash = "sha256-JPoeNB9jM4h+K5vKWi2KQfPJPTUftxwXYJY6eZN50Zs=";
  rke2VendorHash = "sha256-CxNo9HcxuSS0LWawefF0VbtMDofQUzoCzTfBhWAUVrc=";
  k8sImageTag = "v1.31.11-rke2r1-build20250716";
  etcdVersion = "v3.5.21-k3s1-build20250612";
  pauseVersion = "3.6";
  ccmVersion = "v1.31.9-rc1.0.20250516171836-812206503b28-build20250612";
  dockerizedVersion = "v1.31.11-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
