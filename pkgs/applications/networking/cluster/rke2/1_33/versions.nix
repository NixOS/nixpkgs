{
  rke2Version = "1.33.13+rke2r2";
  rke2Commit = "f0fee0e6a6822f36d0cca144c97e33cb979ec184";
  rke2TarballHash = "sha256-WoBZxFMVB9l/KcCfO0RbeBNidZ1uZ8fwilZZQRDNHT8=";
  rke2VendorHash = "sha256-9qYtpCfpmrAEV1gFBke2oeI+lcM6Qzk3MTyuVHmpJLg=";
  k8sImageTag = "v1.33.13-rke2r2-build20260723";
  etcdVersion = "v3.6.14-k3s1-build20260723";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.33.13-0.20260610231102-b1a9339db253-build20260710";
  dockerizedVersion = "v1.33.13-rke2r2";
  helmJobVersion = "v0.13.3-build20260727";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
