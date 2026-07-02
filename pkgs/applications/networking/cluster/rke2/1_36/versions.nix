{
  rke2Version = "1.36.1+rke2r2";
  rke2Commit = "05cf623e2245271b63d1d7ef2caced897636175c";
  rke2TarballHash = "sha256-hxnO8w+ec9cx6betH2hdC50AO/VHmPlseeKV8HgH5ZE=";
  rke2VendorHash = "sha256-gUgRAC9yKDa8JYb/jdCxZdP6500XxjqHprmYlPv5A8c=";
  k8sImageTag = "v1.36.1-rke2r2-build20260521";
  etcdVersion = "v3.6.7-k3s1-build20260512";
  pauseVersion = "3.6";
  ccmVersion = "v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515";
  dockerizedVersion = "v1.36.1-rke2r2";
  helmJobVersion = "v0.10.0-build20260513";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
