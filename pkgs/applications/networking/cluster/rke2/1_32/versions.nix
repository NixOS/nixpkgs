{
  rke2Version = "1.32.11+rke2r1";
  rke2Commit = "836ebdc75f3d96bbeed0373e1fee7de24d3798f7";
  rke2TarballHash = "sha256-AErhQfpUyINPLNaCeXxl67EehB8aKrQUDWZKrFlrG4E=";
  rke2VendorHash = "sha256-yiyMD4VPM592nwbKGEo380FX/B2NytKcw6ly2JSYx7E=";
  k8sImageTag = "v1.32.11-rke2r1-build20251216";
  etcdVersion = "v3.5.25-k3s1-build20251210";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.11-0.20251210094421-ded016535487-build20251210";
  dockerizedVersion = "v1.32.11-rke2r1";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
