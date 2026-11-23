{
  rke2Version = "1.34.13+rke2r1";
  rke2Commit = "5f4b3c5ba1c67b5aee95dbf055faecdb261872fb";
  rke2TarballHash = "sha256-tFh5lewXdc0XJuO0AwCVjYO8hqO1kgFNby3TGfOeXl8=";
  rke2VendorHash = "sha256-XYvWGbAsZhu6UVWtdzmT/Cvy1Jr2N1dUYVQz8BpbDKs=";
  k8sImageTag = "v1.34.13-rke2r1-build20261029";
  etcdVersion = "v3.6.14-k3s3-build20261020";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.34.13-0.20261016153036-a722e6511b81-build20261021";
  dockerizedVersion = "v1.34.13-rke2r1";
  helmJobVersion = "v0.13.3-build20261021";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
