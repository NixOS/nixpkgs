{
  rke2Version = "1.33.3+rke2r1";
  rke2Commit = "4ca66a5fc2eedc38a963f743618b99632fafdd6f";
  rke2TarballHash = "sha256-WQ0o/8oqqTBKRm1qIA0Ek6oHS0ftXytGE61aJUsLI1I=";
  rke2VendorHash = "sha256-l8SDK0tJZNtcWERtP81l6Mac5XmX8hkAgzhtXXs6c+Q=";
  k8sImageTag = "v1.33.3-rke2r1-build20250716";
  etcdVersion = "v3.5.21-k3s1-build20250612";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.1-0.20250516163953-99d91538b132-build20250612";
  dockerizedVersion = "v1.33.3-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
