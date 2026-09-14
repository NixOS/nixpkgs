{
  rke2Version = "1.34.10+rke2r1";
  rke2Commit = "d419f09226d50a4777d348e5c53ea1bce3849b77";
  rke2TarballHash = "sha256-upkkAdlrAkj6RLsIbkNB5KdQylxvb1P47x1AfDcpxfY=";
  rke2VendorHash = "sha256-ep2qR8V3V1F7PHj9rU9hOZb0o4GQVUdtGHyAEWgpM2A=";
  k8sImageTag = "v1.34.10-rke2r1-build20260723";
  etcdVersion = "v3.6.14-k3s1-build20260723";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.34.9-0.20260610230036-3060dff9c388-build20260710";
  dockerizedVersion = "v1.34.10-rke2r1";
  helmJobVersion = "v0.13.3-build20260727";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
