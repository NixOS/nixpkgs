{
  rke2Version = "1.37.2+rke2r1";
  rke2Commit = "972ca61add47eabb7088d1304e523b4e8ee8b04b";
  rke2TarballHash = "sha256-dcdawWYVDbv9FnW9eXRlVCUy4bdy5MWdwaWf7ZM7LBU=";
  rke2VendorHash = "sha256-XIgj/FRW9zB04ma7dELvInhZ92jZt+4ByyKXyQ+iP5A=";
  k8sImageTag = "v1.37.2-rke2r1-build20261029";
  etcdVersion = "v3.7.1-k3s3-build20261020";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.37.2-0.20261016152943-06368081f0b2-build20261021";
  dockerizedVersion = "v1.37.2-rke2r1";
  helmJobVersion = "v0.13.3-build20261021";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
