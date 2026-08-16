{
  rke2Version = "1.35.7+rke2r1";
  rke2Commit = "382a8b31a8fd78e376ab6f02c4bb0ec5592aada2";
  rke2TarballHash = "sha256-+GGX3vfd3JwT+i1ilNx1K4CJV9qlTy9kuOfvA9k21a4=";
  rke2VendorHash = "sha256-OR3BT9/n/LDn9Ngt0/eF2rNfvJmShvTVcWVBVYy2a+Q=";
  k8sImageTag = "v1.35.7-rke2r1-build20260723";
  etcdVersion = "v3.6.14-k3s1-build20260723";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.35.6-0.20260610221957-158346759a70-build20260710";
  dockerizedVersion = "v1.35.7-rke2r1";
  helmJobVersion = "v0.13.3-build20260727";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
