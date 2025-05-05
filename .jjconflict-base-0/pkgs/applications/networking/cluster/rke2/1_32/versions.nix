{
  rke2Version = "1.32.3+rke2r1";
  rke2Commit = "18005e93ee0b015b78be47cf6515ae6d3a9afd55";
  rke2TarballHash = "sha256-rDqSq38WoNN+9dMPTg/iteqkfX/pnlRtzt1HmhkAbRI=";
  rke2VendorHash = "sha256-GwwNXW4JmhvO47V9SysOiKTfK2z55PkWpTDUE2qJgpA=";
  k8sImageTag = "v1.32.3-rke2r1-build20250312";
  etcdVersion = "v3.5.19-k3s1-build20250306";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.0-rc3.0.20241220224140-68fbd1a6b543-build20250101";
  dockerizedVersion = "v1.32.3-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
