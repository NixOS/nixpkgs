{
  rke2Version = "1.33.7+rke2r1";
  rke2Commit = "b0a4ec8463abd1e23e41f213fdb54ad8006c693b";
  rke2TarballHash = "sha256-Dkr+rDsC3L9LSGuu6hBLuyWqWJLrpEi/p35wzP7P0uw=";
  rke2VendorHash = "sha256-ybxWnzKjpH3sYeFIqUZyvV1KXB5zxpjMAzN6oC6MOXo=";
  k8sImageTag = "v1.33.7-rke2r1-build20251210";
  etcdVersion = "v3.5.25-k3s1-build20251210";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.7-0.20251210094413-291666bcc1a4-build20251210";
  dockerizedVersion = "v1.33.7-rke2r1";
  helmJobVersion = "v0.9.12-build20251215";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
