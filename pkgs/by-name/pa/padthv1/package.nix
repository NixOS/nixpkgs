{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  libjack2,
  alsa-lib,
  libsndfile,
  liblo,
  lv2,
  qt5,
  fftwFloat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "padthv1";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/padthv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-Vn1VgzpWgeHxhE+BiVeXrHdkMq5BXMcnS1dG3b33noY=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libjack2
    alsa-lib
    libsndfile
    liblo
    lv2
    qt5.qtbase
    qt5.qttools
    fftwFloat
  ];

  meta = {
    description = "Polyphonic additive synthesizer";
    mainProgram = "padthv1_jack";
    homepage = "http://padthv1.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
