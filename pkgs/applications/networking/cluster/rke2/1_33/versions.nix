{
  rke2Version = "1.33.8+rke2r1";
  rke2Commit = "eb75e3c1774cee5a584259d6fee77eb8cfa9b430";
  rke2TarballHash = "sha256-lurKGrJYKyNVU+MF6k7LFLM+FDnRk0QErcSrookZm7M=";
  rke2VendorHash = "sha256-vobzaY0eyTSEaZ1AwWaPuK6VhTcRW1YO9gIpMgsQo0g=";
  k8sImageTag = "v1.33.8-rke2r1-build20260210";
  etcdVersion = "v3.5.26-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.8-0.20260211145912-3552cfc26032-build20260211";
  dockerizedVersion = "v1.33.8-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
