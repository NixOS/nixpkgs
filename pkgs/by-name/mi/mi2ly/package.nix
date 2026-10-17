{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mi2ly";
  version = "0.12";

  src = fetchurl {
    url = "mirror://savannah/mi2ly/mi2ly.${finalAttrs.version}.tar.bz2";
    hash = "sha256-lFbqH+syFaQDMbXfb+OUcWnyKnjfVz9yl7DbTTn7JKw=";
  };

  sourceRoot = ".";

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fgnu89-inline" ];

  buildPhase = "./cc";
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/mi2ly}
    cp mi2ly "$out/bin"
    cp README Doc.txt COPYING Manual.txt "$out/share/doc/mi2ly"
  '';

  meta = {
    description = "MIDI to Lilypond converter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://www.nongnu.org/mi2ly/";
    mainProgram = "mi2ly";
  };
})
