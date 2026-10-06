{
  rke2Version = "1.36.4+rke2r1";
  rke2Commit = "7479a59cdd2c8ce0b8871699a24daa4b7c28cc64";
  rke2TarballHash = "sha256-VO7epe6yWZ1RMN/mhJ3ZkERigHW1gEcRw+K/kmtEpA4=";
  rke2VendorHash = "sha256-QmMQieCBIZ0X0d/OkdznQPN/I8NH+mX7vjWaMWOfKjQ=";
  k8sImageTag = "v1.36.4-rke2r1-build20260821";
  etcdVersion = "v3.6.14-k3s1-build20260819";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.36.4-0.20260817193921-a2fc9574e060-build20260820";
  dockerizedVersion = "v1.36.4-rke2r1";
  helmJobVersion = "v0.13.3-build20260820";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
