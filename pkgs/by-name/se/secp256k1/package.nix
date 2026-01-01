{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "secp256k1";

  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    tag = "v${version}";
    sha256 = "sha256-pCSNUSrPyN/lLYZm7zK/b9LICkThXOr6JAyFvHZSPW0=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-benchmark=no"
    "--enable-module-recovery"
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
      Optimized C library for EC operations on curve secp256k1. Part of
      Bitcoin Core. This library is a work in progress and is being used
      to research best practices. Use at your own risk.
    '';
    homepage = "https://github.com/bitcoin-core/secp256k1";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = with lib.platforms; all;
=======
    license = with licenses; [ mit ];
    maintainers = [ ];
    platforms = with platforms; all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
