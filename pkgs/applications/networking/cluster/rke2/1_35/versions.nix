{
  rke2Version = "1.35.0+rke2r1";
  rke2Commit = "233368982cc7242d3eb01e22112343839e8e8f2d";
  rke2TarballHash = "sha256-spnfiv5butC6yh9h3uosS0M5jTbPAuy6N+jzdri9Ano=";
  rke2VendorHash = "sha256-DSIhALF+Ic1zm52YntGoBbbJkeq0SX7QkpyOQ9z2+Qo=";
  k8sImageTag = "v1.35.0-rke2r1-build20251218";
  etcdVersion = "v3.6.6-k3s1-build20251210";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.0-rc1.0.20251218152248-a6c6cd15c0c4-build20251219";
  dockerizedVersion = "v1.35.0-rke2r1";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
