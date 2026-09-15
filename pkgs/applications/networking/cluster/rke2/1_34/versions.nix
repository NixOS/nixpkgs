{
  rke2Version = "1.34.11+rke2r1";
  rke2Commit = "2506fee512985398ca0b50d875c3df73069763ce";
  rke2TarballHash = "sha256-jrXi8KZmq+yGSKaVUUsZ+mNKzV1cSTOLPkPFye+OdpI=";
  rke2VendorHash = "sha256-AYsoVlykxpyIeVpuXpEY4uKJ3NyzRlOdOiJJl22m8VA=";
  k8sImageTag = "v1.34.11-rke2r1-build20260821";
  etcdVersion = "v3.6.14-k3s1-build20260819";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.34.11-0.20260817193950-75826e8afefa-build20260820";
  dockerizedVersion = "v1.34.11-rke2r1";
  helmJobVersion = "v0.13.3-build20260820";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
