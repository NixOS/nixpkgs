{
  rke2Version = "1.30.12+rke2r1";
  rke2Commit = "f885aec181ca47674d94d52376438adb504014fe";
  rke2TarballHash = "sha256-qOdIrC8M4ZLLzF2GEx9Osl5Qs+HQXt8JRdlkLCqR8rE=";
  rke2VendorHash = "sha256-GLyifHh+fbncRhsN+u7L5CgoOmUJTPuhsSKvtQUNQdQ=";
  k8sImageTag = "v1.30.12-rke2r1-build20250423";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.30.6-0.20241016053533-5ec454f50e7a-build20241016";
  dockerizedVersion = "v1.30.12-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
