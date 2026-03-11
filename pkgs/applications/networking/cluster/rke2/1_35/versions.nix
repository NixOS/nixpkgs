{
  rke2Version = "1.35.1+rke2r1";
  rke2Commit = "f50bba7b99629037843f9a8d844cf91b62f546f7";
  rke2TarballHash = "sha256-fqDfpa1CLlIBi6QnTQl9OIepr4kbY1gDjZNJXSdHP1I=";
  rke2VendorHash = "sha256-i8dhiWA3WGljYIrp09oVt92HI0xkqhEfJgojVNNEsLQ=";
  k8sImageTag = "v1.35.1-rke2r1-build20260210";
  etcdVersion = "v3.6.7-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.1-0.20260211145923-50fa2d70c239-build20260211";
  dockerizedVersion = "v1.35.1-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
