{
  rke2Version = "1.29.15+rke2r1";
  rke2Commit = "c228232895f83b6c3e17a9741e0c8d8e4439894d";
  rke2TarballHash = "sha256-ZvujSxuTsM6oBNEehQSMmCkbSTsp8sBZd00vwJGx5Lk=";
  rke2VendorHash = "sha256-PhJgHvVCZAxWK78cn0pURC/Oy63/V41k0ZFn4sveCPY=";
  k8sImageTag = "v1.29.15-rke2r1-build20250312";
  etcdVersion = "v3.5.19-k3s1-build20250306";
  pauseVersion = "3.6";
  ccmVersion = "v1.29.10-0.20241016053521-9510ac25fefb-build20241016";
  dockerizedVersion = "v1.29.15-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
