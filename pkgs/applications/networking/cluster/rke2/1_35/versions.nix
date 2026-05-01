{
  rke2Version = "1.35.2+rke2r1";
  rke2Commit = "b1cd9d8e735bcd84cad7407109423a8dd7b648d8";
  rke2TarballHash = "sha256-s5lZK7S+WReRF+Io9+X4bSd6mAvBq9qUXbYEOH++cFA=";
  rke2VendorHash = "sha256-3i//hVONK/QxIsiOth92fN0Rxw6Ex4cgBQe7NG//URc=";
  k8sImageTag = "v1.35.2-rke2r1-build20260227";
  etcdVersion = "v3.6.7-k3s1-build20260227";
  pauseVersion = "3.6";
  ccmVersion = "v1.35.1-0.20260211145923-50fa2d70c239-build20260211";
  dockerizedVersion = "v1.35.2-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
