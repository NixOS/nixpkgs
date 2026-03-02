{
  rke2Version = "1.34.4+rke2r1";
  rke2Commit = "c6b97dc03cefec17e8454a6f45b29f4e3d0a81d6";
  rke2TarballHash = "sha256-aYqmYongTjCKh5ntRhyv8w/+MUDjY7HLqkgWvQacR2M=";
  rke2VendorHash = "sha256-Asuqicq2xXdT3nL1OZ6M8yEPzhECNvrC9Yswc4g+oHQ=";
  k8sImageTag = "v1.34.4-rke2r1-build20260210";
  etcdVersion = "v3.6.7-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.4-0.20260211145917-c6017918a65c-build20260211";
  dockerizedVersion = "v1.34.4-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
