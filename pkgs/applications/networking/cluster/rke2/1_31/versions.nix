{
  rke2Version = "1.31.14+rke2r1";
  rke2Commit = "a594ea8cf80ad7b2b55f1b0286b34c8af7d53c30";
  rke2TarballHash = "sha256-1IQdJPF546DX7eHPoA0rIfUJs3uZSTDXfn5OnJbU7FQ=";
  rke2VendorHash = "sha256-HmJyX7QsuB5g0bajgExMi2rg9jTTTUZiuYXlrfNA5xo=";
  k8sImageTag = "v1.31.14-rke2r1-build20251112";
  etcdVersion = "v3.5.21-k3s1-build20251017";
  pauseVersion = "3.6";
  ccmVersion = "v1.31.14-0.20251010190929-c49b201b7cf5-build20251017";
  dockerizedVersion = "v1.31.14-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
