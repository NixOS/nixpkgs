{
  buildGoModule,
  fetchFromGitHub,
  lib,
  upstreamSrc,
  version,
}:

let
  secp256k1 = fetchFromGitHub {
    owner = "ltcmweb";
    repo = "secp256k1";
    rev = "v0.1.1";
    fetchSubmodules = true;
    hash = "sha256-dnv+w5WGN0mB5xASeu1tPjWAevZJVkYYXmcHdn5VgiM=";
  };
in
buildGoModule (finalAttrs: {
  pname = "cake-wallet-mweb";
  inherit version;
  src = upstreamSrc;

  sourceRoot = "${finalAttrs.src.name}/cw_mweb/go";
  vendorHash = "sha256-PeS16aRg5sGvnIyqktN5424Q6dxqR+tQIgLEowahC5k=";

  buildPhase = ''
    runHook preBuild
    chmod -R u+w vendor
    rm -rf vendor/github.com/ltcmweb/secp256k1
    cp -R ${secp256k1} vendor/github.com/ltcmweb/secp256k1
    chmod -R u+w vendor/github.com/ltcmweb/secp256k1
    go build -buildmode=c-shared -o libmweb.so .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 libmweb.so "$out/lib/libmweb.so"
    install -Dm644 libmweb.h "$out/include/libmweb.h"
    runHook postInstall
  '';

  passthru = {
    inherit secp256k1;
  };

  meta = {
    description = "Litecoin MWEB library used by Cake Wallet";
    homepage = "https://github.com/cake-tech/cake_wallet";
    platforms = lib.platforms.linux;
  };
})
