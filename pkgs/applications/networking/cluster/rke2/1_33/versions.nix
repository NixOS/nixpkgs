{
  rke2Version = "1.33.0+rke2r1";
  rke2Commit = "a9a0c194cbd38117b034ddd09ff7a4da0c8efe46";
  rke2TarballHash = "sha256-xXQBmLy7sGwGSoaA9D6g69WYq0C4IyMZNfflCY1SufE=";
  rke2VendorHash = "sha256-uEXWwiLWmf6Iyc9pDZGV7OYGBuTFF5uPLTXmkg5T4kA=";
  k8sImageTag = "v1.33.0-rke2r1-build20250425";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.0-rc1.0.20250430074337-dc03cb4b3faa-build20250430";
  dockerizedVersion = "v1.33.0-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
