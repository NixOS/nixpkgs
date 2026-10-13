{
  rke2Version = "1.35.8+rke2r1";
  rke2Commit = "0fec82ea2fa6c7b25b7a3fe3cd990fbecc07e1bb";
  rke2TarballHash = "sha256-WtdKeJ/AbUJaY+ovYZAEpDpWNXYFvJwkPf2V533cIn8=";
  rke2VendorHash = "sha256-+OaVavHIG6Xx3bOBi90PXKI28dSQWtKHV8A+7EbbF7E=";
  k8sImageTag = "v1.35.8-rke2r1-build20260821";
  etcdVersion = "v3.6.14-k3s1-build20260819";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.35.8-0.20260817193936-20fc9c33a412-build20260820";
  dockerizedVersion = "v1.35.8-rke2r1";
  helmJobVersion = "v0.13.3-build20260820";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
