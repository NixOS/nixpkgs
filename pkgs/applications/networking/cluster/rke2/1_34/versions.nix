{
  rke2Version = "1.34.3+rke2r1";
  rke2Commit = "1b103f296ab20fac6b32951c9efe59d28a5ed79f";
  rke2TarballHash = "sha256-94wB6Dt06/evdQcW1K8blNBHwNR3ZGCZPLJyeyMbYAM=";
  rke2VendorHash = "sha256-hVEIhaF5gabDKWX2VCTyKQa0cZktO9w+l2JtSNQIkg8=";
  k8sImageTag = "v1.34.3-rke2r1-build20251210";
  etcdVersion = "v3.6.6-k3s1-build20251210";
  pauseVersion = "3.6";
  ccmVersion = "v1.34.3-0.20251210094406-1ff6ebef7028-build20251210";
  dockerizedVersion = "v1.34.3-rke2r1";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
