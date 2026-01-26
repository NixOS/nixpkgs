{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lambda-delta";
  version = "0.98.3";

  src = fetchFromGitHub {
    owner = "dseagrav";
    repo = "ld";
    rev = finalAttrs.version;
    sha256 = "02m43fj9dzc1i1jl01qwnhjiq1rh03jw1xq59sx2h3bhn7dk941x";
  };

  patches = [ ./fix-implicit-int.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ SDL2 ];
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-std=c89";
  };

  configureFlags = [ "--without-SDL1" ];

  meta = {
    description = "LMI (Lambda Lisp Machine) emulator";
    homepage = "https://github.com/dseagrav/ld";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
