{
  rke2Version = "1.35.0+rke2r3";
  rke2Commit = "25ce2b8aa70af95611e0cd762079bbd1ee0006df";
  rke2TarballHash = "sha256-HCdUc15OIQy+UBSXnaXift8KGbD2PfQCBuCacGKWjKw=";
  rke2VendorHash = "sha256-gWb2rTpyAxhnl/OSzApsk/Ryo9tQud65a4TJC4d1eU4=";
  k8sImageTag = "v1.35.0-rke2r3-build20260127";
  etcdVersion = "v3.6.7-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.0-rc1.0.20251218152248-a6c6cd15c0c4-build20251219";
  dockerizedVersion = "v1.35.0-rke2r3";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
