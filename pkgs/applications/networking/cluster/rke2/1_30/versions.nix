{
  rke2Version = "1.30.14+rke2r2";
  rke2Commit = "0fbe6e3807663c335ac08ae6cae409a6b268e888";
  rke2TarballHash = "sha256-f8D8+fQ6NTRUT0NAEUGsOjOevsmpDoNM7PaMmA6ZF1M=";
  rke2VendorHash = "sha256-WyUqzOTKjLkkW1g5gkuftaKNW8jm9TZJ2oKPOFT2mFY=";
  k8sImageTag = "v1.30.14-rke2r2-build20250716";
  etcdVersion = "v3.5.21-k3s1-build20250612";
  pauseVersion = "3.6";
  ccmVersion = "v1.30.13-rc1.0.20250516172343-e77f78ee9466-build20250613";
  dockerizedVersion = "v1.30.14-rke2r2";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
