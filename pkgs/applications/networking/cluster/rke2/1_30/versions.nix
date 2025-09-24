{
  rke2Version = "1.30.11+rke2r1";
  rke2Commit = "406a7f6db944b045d8d3ba871b2481b2ebb3f68f";
  rke2TarballHash = "sha256-j3Pp+YYS3j0noJ7K1Ub2tNL5JfQyvVgYVck1TCvQq/w=";
  rke2VendorHash = "sha256-RiJd4OS0gPICHzcv5brsxwl6FPqlt+HXYWI4xlFXLNU=";
  k8sImageTag = "v1.30.11-rke2r1-build20250312";
  etcdVersion = "v3.5.19-k3s1-build20250306";
  pauseVersion = "3.6";
  ccmVersion = "v1.30.6-0.20241016053533-5ec454f50e7a-build20241016";
  dockerizedVersion = "v1.30.11-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
