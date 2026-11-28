{
  rke2Version = "1.35.10+rke2r1";
  rke2Commit = "b9ef39138c61123c13e69d8e6a302435e42cfb5b";
  rke2TarballHash = "sha256-FwdI03QYu/GIByySg2Bqluj3ISMV+cNrmeJ7nD0Emas=";
  rke2VendorHash = "sha256-r42AILW5vwVLk1SL97OlqBgfVd99H8dX/uGlRT1NFtU=";
  k8sImageTag = "v1.35.10-rke2r1-build20261029";
  etcdVersion = "v3.6.14-k3s3-build20261020";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.35.10-0.20261016153020-10a456cdc331-build20261021";
  dockerizedVersion = "v1.35.10-rke2r1";
  helmJobVersion = "v0.13.3-build20261021";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
