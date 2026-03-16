{
  rke2Version = "1.33.9+rke2r1";
  rke2Commit = "91477e5799063a35553b4d855e7a21bdd53c7009";
  rke2TarballHash = "sha256-2QLG5FHmKQJWu/UjdwtXvXpoNu/to29ORDbo7SgjXSI=";
  rke2VendorHash = "sha256-1hkGjui1RDE8UzK7h2SrhYwUX59lRsHLJ3g/OQZ9JTQ=";
  k8sImageTag = "v1.33.9-rke2r1-build20260227";
  etcdVersion = "v3.5.26-k3s1-build20260227";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.8-0.20260211145912-3552cfc26032-build20260211";
  dockerizedVersion = "v1.33.9-rke2r1";
  helmJobVersion = "v0.9.14-build20260210";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
