{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "secp256k1";

  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-748wsQsZpbZPVVNBhCQW7xbsR8XkRu2Ikx6s/Dl1elg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-benchmark=no"
    "--enable-module-recovery"
  ];

  doCheck = true;

  meta = {
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
      Optimized C library for EC operations on curve secp256k1. Part of
      Bitcoin Core. This library is a work in progress and is being used
      to research best practices. Use at your own risk.
    '';
    homepage = "https://github.com/bitcoin-core/secp256k1";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; all;
  };
})
