{
  rke2Version = "1.31.8+rke2r1";
  rke2Commit = "f598b218a6f58bd566d6d757a352efb8260de42e";
  rke2TarballHash = "sha256-RwgIE2l0e6WYI6CLYwwdPFzcjKwUpr5NcQ5eFctZBYc=";
  rke2VendorHash = "sha256-PwNzAA+1qWw8me3SXI+97B/c6qo2QsE/5n+3uPUVLCM=";
  k8sImageTag = "v1.31.8-rke2r1-build20250423";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.31.2-0.20241016053446-0955fa330f90-build20241016";
  dockerizedVersion = "v1.31.8-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
