{
  rke2Version = "1.33.6+rke2r1";
  rke2Commit = "2c2298232b55a94bd16b059f893c76a950811489";
  rke2TarballHash = "sha256-K58K5jqOtabjyG1MIfvnaMo4pePgWaAd9SQ5BCNo3nw=";
  rke2VendorHash = "sha256-taNWaULzVE3d4MhHvet3JFH3Mb4m/8no+DzIhqAjyVw=";
  k8sImageTag = "v1.33.6-rke2r1-build20251112";
  etcdVersion = "v3.5.21-k3s1-build20251017";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.6-0.20251010190850-d6b5244412d1-build20251017";
  dockerizedVersion = "v1.33.6-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
