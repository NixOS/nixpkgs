{
  rke2Version = "1.32.4+rke2r1";
  rke2Commit = "4e465c0f03edba9a2af3b3c77d09840d3f7681ef";
  rke2TarballHash = "sha256-xG/x6UjvL7VjLw14k4lduB6ODWUfXs3/z9BWO28BKAM=";
  rke2VendorHash = "sha256-HYlfM8/X0BFNea1MySoB8JuSCOZW3FVM5FogLfAuj0c=";
  k8sImageTag = "v1.32.4-rke2r1-build20250423";
  etcdVersion = "v3.5.21-k3s1-build20250411";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.0-rc3.0.20241220224140-68fbd1a6b543-build20250101";
  dockerizedVersion = "v1.32.4-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
