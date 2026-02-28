{
  rke2Version = "1.32.12+rke2r1";
  rke2Commit = "74d4362acaa7234e3fc909841cdaf906c73eb6f5";
  rke2TarballHash = "sha256-DC0XG/m6/ApzLUFBykGGHNBRTPYhCqAJNxhYpXk4Zzc=";
  rke2VendorHash = "sha256-wMxOKsnf6s3CB2+ocjHovXa/RUJPAZT0WubcnUZMiV8=";
  k8sImageTag = "v1.32.12-rke2r1-build20260210";
  etcdVersion = "v3.5.26-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.12-0.20260211145907-0dc662e80238-build20260211";
  dockerizedVersion = "v1.32.12-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
