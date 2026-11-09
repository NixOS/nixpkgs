{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pandoc,
  pkg-config,
  alsa-lib,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmetronome";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/kmetronome/${finalAttrs.version}/kmetronome-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ipWDhktU6D1d0A9TZPxB12TFdF8XyPIJtnAw/ULt0So=";
  };

  nativeBuildInputs = [
    cmake
    pandoc
    pkg-config
    qt6Packages.qttools
  ];

  buildInputs = [
    alsa-lib
    qt6Packages.drumstick
    qt6Packages.qtbase
    qt6Packages.qtsvg
  ];

  dontWrapQtApps = true;

  meta = {
    homepage = "https://kmetronome.sourceforge.io/";
    description = "ALSA MIDI metronome with Qt interface";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "kmetronome";
  };
})
