{
  rke2Version = "1.37.1+rke2r1";
  rke2Commit = "bb33a3e8f191b46f773bd4eae2fe471927126c1b";
  rke2TarballHash = "sha256-ezTW6Xhf3hxizz6Lv/aa9NjaXa0z9fANAsaoEY1W6v4=";
  rke2VendorHash = "sha256-vvKAp2VgId0H9kxNrJos+ANPFgc3MV3cNdeUvFv+io0=";
  k8sImageTag = "v1.37.1-rke2r1-build20260924";
  etcdVersion = "v3.7.1-k3s3-build20260915";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.37.1-0.20260915225838-315ede265f11-build20260916";
  dockerizedVersion = "v1.37.1-rke2r1";
  helmJobVersion = "v0.13.3-build20260909";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
