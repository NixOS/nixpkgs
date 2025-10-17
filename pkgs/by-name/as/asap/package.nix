{
  stdenv,
  lib,
  fetchzip,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asap";
  version = "6.0.3";

  src = fetchzip {
    url = "mirror://sourceforge/project/asap/asap/${finalAttrs.version}/asap-${finalAttrs.version}.tar.gz";
    hash = "sha256-a4RUtFue5wdoGUykLRb46s4+yR/I/7DhwE1SiWPRg8s=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    SDL
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    # Only targets that don't need cito transpiler
    "asapconv"
    "asap-sdl"
    "lib"
  ];

  installFlags = [
    "prefix=${placeholder "dev"}"
    "bindir=${placeholder "out"}/bin"
    "install-asapconv"
    "install-sdl"
    "install-lib"
  ];

  meta = {
    homepage = "https://asap.sourceforge.net/";
    mainProgram = "asap-sdl";
    description = "Another Slight Atari Player";
    longDescription = ''
      ASAP (Another Slight Atari Player) plays and converts 8-bit Atari POKEY
      music (*.sap, *.cmc, *.mpt, *.rmt, *.tmc, ...) on modern computers and
      mobile devices.
    '';
    maintainers = with lib.maintainers; [ OPNA2608 ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
