{
  rke2Version = "1.32.11+rke2r3";
  rke2Commit = "17d79026f5b83f1ca4af3feadc4756cc0cce0ba1";
  rke2TarballHash = "sha256-lu5Au09HF8Vhle/caMYIlrtxplbikzS4JpFvZwbm5Bg=";
  rke2VendorHash = "sha256-wniGN8nRXo8GDKXG5wt/Ulv5A4IIIyVh6GFpfFfebRQ=";
  k8sImageTag = "v1.32.11-rke2r3-build20260127";
  etcdVersion = "v3.5.26-k3s1-build20260126";
  pauseVersion = "3.6";
  ccmVersion = "v1.32.11-0.20251210094421-ded016535487-build20251210";
  dockerizedVersion = "v1.32.11-rke2r3";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
