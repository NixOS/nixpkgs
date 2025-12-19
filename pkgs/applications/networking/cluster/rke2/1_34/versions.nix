{
  rke2Version = "1.34.2+rke2r1";
  rke2Commit = "5e3fff8134a5269977762be64197d0cb9b26b48c";
  rke2TarballHash = "sha256-qd8oD51x2tiIRLWWA5rWUVp/stBB2ebe8dFIB5XuZME=";
  rke2VendorHash = "sha256-0qsCo/9kttOaFqOwfNfwxaG9z+EAdk15Dde3Gw5tK98=";
  k8sImageTag = "v1.34.2-rke2r1-build20251112";
  etcdVersion = "v3.6.5-k3s1-build20251017";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.2-0.20251010190833-cf0d35a732d1-build20251017";
  dockerizedVersion = "v1.34.2-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
