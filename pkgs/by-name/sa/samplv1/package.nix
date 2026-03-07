{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  alsa-lib,
  liblo,
  libsndfile,
  lv2,
  rubberband,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samplv1";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/samplv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-TG1pDiBnNXGIAnzIs8uYxEq0Ah0fABMlBs8Iq4lkQes=";
  };

  nativeBuildInputs = [
    kdePackages.qttools
    pkg-config
    kdePackages.wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    libjack2
    alsa-lib
    liblo
    libsndfile
    lv2
    kdePackages.qtbase
    rubberband
    kdePackages.qtsvg
  ];

  meta = {
    description = "Old-school all-digital polyphonic sampler synthesizer with stereo fx";
    mainProgram = "samplv1_jack";
    homepage = "http://samplv1.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
