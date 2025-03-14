{
  lib,
  stdenv,
  fetchFromGitHub,
  libuv,
  lz4,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "maxcso";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "unknownbrackets";
    repo = "maxcso";
    rev = "v${version}";
    sha256 = "sha256-6LjR1ZMZsi6toz9swPzNmSAlrUykwvVdYi1mR8Ctq5U=";
  };

  buildInputs = [
    libuv
    lz4
    zlib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/unknownbrackets/maxcso";
    description = "A fast ISO to CSO compression program for use with PSP and PS2 emulators, which uses multiple algorithms for best compression ratio";
    maintainers = with maintainers; [ david-sawatzke ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.isc;
    mainProgram = "maxcso";
  };
}
