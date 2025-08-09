{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpp";
  version = "2.7.2.2";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "mcpp";
    rev = finalAttrs.version;
    hash = "sha256-wz225bhBF0lFerOAhl8Rwmw8ItHd9BXQceweD9BqvEQ=";
  };

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  patches = [
    ./readlink.patch
  ];

  configureFlags = [ "--enable-mcpplib" ];

  meta = with lib; {
    homepage = "https://github.com/museoa/mcpp";
    description = "Matsui's C preprocessor";
    mainProgram = "mcpp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
})
