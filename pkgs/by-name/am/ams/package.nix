{
  lib,
  stdenv,
  fetchgit,
  alsa-lib,
  ladspa-header,
  libjack2,
  fftw,
  zita-alsa-pcmi,
  qt5,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ams";
  version = "220";

  src = fetchgit {
    url = "https://git.code.sf.net/p/alsamodular/ams.git";
    hash = "sha256-6aO5Vs8lplcuEs7hGmT2stB90q8h9tDxcCSpS2n5vmE=";
    tag = "Release-${finalAttrs.version}";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ladspa-header
    libjack2
    fftw
    zita-alsa-pcmi
  ]
  ++ (with qt5; [
    qtbase
    qttools
  ]);

  meta = {
    description = "Realtime modular synthesizer for ALSA";
    mainProgram = "ams";
    homepage = "https://alsamodular.sourceforge.net";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sjfloat ];
  };
})
