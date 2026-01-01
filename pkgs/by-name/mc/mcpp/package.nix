{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpp";
<<<<<<< HEAD
  version = "2.7.2.3";
=======
  version = "2.7.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "mcpp";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-g+dqyC9Aik9vxqmixRKzV5GCLiw2tk8mJDHJ/HyiHKw=";
=======
    hash = "sha256-wz225bhBF0lFerOAhl8Rwmw8ItHd9BXQceweD9BqvEQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  patches = [
    ./readlink.patch
  ];

  configureFlags = [ "--enable-mcpplib" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/museoa/mcpp";
    description = "Matsui's C preprocessor";
    mainProgram = "mcpp";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://github.com/museoa/mcpp";
    description = "Matsui's C preprocessor";
    mainProgram = "mcpp";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
