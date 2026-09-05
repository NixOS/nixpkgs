import ./generic.nix {
  version = "7.5.0";
  production = false;
  hash = "sha256-OMQuNfm9xqXaDexuoDRvvSEoEb7hXEMF7ynRU3CawbI=";
  webVersion = "7.4.0";
  webHash = "sha256-idoR5R97k5ZfYBh7vboXzg2CdbVX5TBPrpL6s1k9qPA=";
  webPnpmDepsHash = "sha256-h2QNq51GE8qnLsvPhDobzT/8am0jzbW6Mx6tnungY/k=";
  idpWebPnpmDepsHash = "sha256-rj6KFrzuINVpxrrel2p2iWtJVH8Zg1jrZEIAs8S+8Qs=";
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/op/opencloud/package.nix"
  ];
}
