{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "lambda-delta";
  version = "0.98.3";

  src = fetchFromGitHub {
    owner = "dseagrav";
    repo = "ld";
    rev = version;
    sha256 = "02m43fj9dzc1i1jl01qwnhjiq1rh03jw1xq59sx2h3bhn7dk941x";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ SDL2 ];
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-std=c89";
  };

  configureFlags = [ "--without-SDL1" ];

  meta = with lib; {
    description = "LMI (Lambda Lisp Machine) emulator";
    homepage = "https://github.com/dseagrav/ld";
    license = licenses.gpl2;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
