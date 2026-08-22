{
  lib,
  cmake,
  fftw,
  kdePackages,
  libhwy,
  libmpdclient,
  projectm_3,
  libpulseaudio,
  pipewire,
  pkg-config,
  buildPackages,
  fetchgit,
  pkgsBuildTarget,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "quester";
  version = "0.1.0";

  src = fetchgit {
    url = "https://codeberg.org/anoraktrend/quester";
    rev = "b7c600244e6d391398014ef9a44898e22659dd39";
    hash = "sha256-IE0a1zvg+AzIt4T1vloItE+a+qdA2HCrKlIcMg6bwc8=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    fftw
    kdePackages.extra-cmake-modules
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    libhwy
    libmpdclient
    projectm_3
    libpulseaudio
    pipewire
    pkg-config
  ];

  postPatch = ''
    sed -i '147,149d' CMakeLists.txt
  '';

  __structuredAttrs = true;

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://codeberg.org/anoraktrend/quester";
    description = "A QML-based MPD Client.";
    longDescription = ''
      A modern, visually rich MPD client built with Qt 6 and QML

      Quester is a desktop client for the Music Player Daemon (MPD). It provides a fluid user interface focused on album art and visual feedback. Built using C++ and Qt Quick (QML), it aims to offer a lightweight yet visually appealing way to browse and play your music library.
    '';
    license = lib.licenses.mit;
    mainProgram = "quester";
    maintainers = with lib.maintainers; [
      sed4906
    ];
    platforms = lib.platforms.unix;
  };
}
