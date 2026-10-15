{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpp";
  version = "2.7.2.3";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "mcpp";
    rev = finalAttrs.version;
    hash = "sha256-g+dqyC9Aik9vxqmixRKzV5GCLiw2tk8mJDHJ/HyiHKw=";
  };

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  patches = [
    ./readlink.patch
  ];

  configureFlags = [ "--enable-mcpplib" ];

  meta = {
    homepage = "https://github.com/museoa/mcpp";
    description = "Matsui's C preprocessor";
    mainProgram = "mcpp";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
