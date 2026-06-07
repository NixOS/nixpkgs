{
  rke2Version = "1.36.1+rke2r1";
  rke2Commit = "b4a8e78038f35eb282a8d6e3c29797a1181fa961";
  rke2TarballHash = "sha256-SD7+lNYu6/5iMxEmHEpkD8g9UCgN6gjkFsGdQn9o1Cc=";
  rke2VendorHash = "sha256-gUgRAC9yKDa8JYb/jdCxZdP6500XxjqHprmYlPv5A8c=";
  k8sImageTag = "v1.36.1-rke2r1-build20260512";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.36.0-rc2.0.20260427154526-d239025e2a23-build20260429";
  dockerizedVersion = "v1.36.1-rke2r1";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
