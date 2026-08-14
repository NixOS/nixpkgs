{
  rke2Version = "1.36.3+rke2r1";
  rke2Commit = "c4f306e6c5fa18dfb447bf6b8a0423f2da68c939";
  rke2TarballHash = "sha256-KNYRnek5EcHE2Xu6sYdKKqmzJ/h4LuaR/KIILyHAmoM=";
  rke2VendorHash = "sha256-0SuhW4tRv7YZCNNCRikGYRw1DVaWvaZ1/q83Uko6YAg=";
  k8sImageTag = "v1.36.3-rke2r1-build20260723";
  etcdVersion = "v3.6.14-k3s1-build20260723";
  pauseVersion = "3.10.2";
  ccmVersion = "v1.36.2-0.20260610225606-10b320a3ba51-build20260709";
  dockerizedVersion = "v1.36.3-rke2r1";
  helmJobVersion = "v0.13.3-build20260727";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
