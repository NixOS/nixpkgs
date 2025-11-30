{
  rke2Version = "1.32.9+rke2r1";
  rke2Commit = "d00da43053c862ae59b91d94844c4addd5bd056f";
  rke2TarballHash = "sha256-rpSHXLM06IckB3Je6Nx+riVXjd4stU4KcO9Sid/rSK0=";
  rke2VendorHash = "sha256-MbDVrlv0FR8MKMpi3zjGx2PuAgvQzzwb/JBIWCVUcsI=";
  k8sImageTag = "v1.32.9-rke2r1-build20250910";
  etcdVersion = "v3.5.21-k3s1-build20250910";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.8-rc1.0.20250814215348-fe896f7e7cf8-build20250908";
  dockerizedVersion = "v1.32.9-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
