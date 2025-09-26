{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ladspa-sdk,
  lash,
  libarchive,
  libjack2,
  liblo,
  libpulseaudio,
  libsndfile,
  lrdf,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydrogen";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "hydrogen-music";
    repo = "hydrogen";
    tag = finalAttrs.version;
    hash = "sha256-JK4AAGMby2S2fh9bmgb2mSHBgKfUQ481GDjAvOdSnjs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib
    ladspa-sdk
    lash
    libarchive
    libjack2
    liblo
    libpulseaudio
    libsndfile
    lrdf
  ]
  ++ (with qt5; [
    qtbase
    qttools
    qtxmlpatterns
  ]);

  cmakeFlags = [
    "-DWANT_DEBUG=OFF"
  ];

  meta = {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orivej ];
  };
})
