{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gzrt";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "arenn";
    repo = "gzrt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2RzQ/xrtADplVqUeB6suU3fKhJePYM7EkuIV59JSR3Q=";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp gzrecover $out/bin
  '';

  meta = {
    homepage = "https://github.com/arenn/gzrt";
    description = "Gzip Recovery Toolkit";
    maintainers = [ ];
    mainProgram = "gzrecover";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
