{
  rke2Version = "1.34.5+rke2r1";
  rke2Commit = "105ddbd880270e1edcf8ea26a73e1f9be922ec83";
  rke2TarballHash = "sha256-Wc0kZsPfxSi+HoNLo//CYDUROiOkdYreUkcnlYQc7uA=";
  rke2VendorHash = "sha256-qYMOtIyRb3iZnEunssZOO/O8a9muhFZr62rLH9P7+WU=";
  k8sImageTag = "v1.34.5-rke2r1-build20260227";
  etcdVersion = "v3.6.7-k3s1-build20260227";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.4-0.20260211145917-c6017918a65c-build20260211";
  dockerizedVersion = "v1.34.5-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
