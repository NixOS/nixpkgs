{
  lib,
  stdenv,
  fetchFromGitHub,
  libuv,
  lz4,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maxcso";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "unknownbrackets";
    repo = "maxcso";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6LjR1ZMZsi6toz9swPzNmSAlrUykwvVdYi1mR8Ctq5U=";
  };

  buildInputs = [
    libuv
    lz4
    zlib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/unknownbrackets/maxcso";
    description = "Fast ISO to CSO compression program for use with PSP and PS2 emulators, which uses multiple algorithms for best compression ratio";
    maintainers = with lib.maintainers; [ david-sawatzke ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.isc;
    mainProgram = "maxcso";
  };
})
