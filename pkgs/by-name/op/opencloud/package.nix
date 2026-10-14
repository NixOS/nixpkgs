import ./generic.nix {
  version = "8.1.0";
  production = false;
  hash = "sha256-Y7S26FWP+QkOdbuwu32xOgpAoupIoOnCu3KtzNjKev0=";
  webVersion = "8.1.0";
  webHash = "sha256-AiRxobjUk38IqCoSzoijMbLPzQGdSFeRCTIkKGfcR90=";
  webPnpmDepsHash = "sha256-z+uy+Ys0wflLNtUqbfETfkztOmkN72cAptBPOytdMXg=";
  idpWebPnpmDepsHash = "sha256-rj6KFrzuINVpxrrel2p2iWtJVH8Zg1jrZEIAs8S+8Qs=";
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/op/opencloud/package.nix"
  ];
}
