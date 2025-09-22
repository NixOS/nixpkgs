{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  qt6,
  libvorbis,
  libarchive,
  libxml2,
}:

stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "stopmotion";

  src = fetchgit {
    url = "https://invent.kde.org/multimedia/stopmotion";
    rev = version;
    hash = "sha256-RsFqvAmTJBVg32bnY2eA9jWWnuHgv66rZiWMqa6sviw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    libvorbis
    libarchive
    libxml2
  ];

  meta = with lib; {
    description = "Create stop-motion animation movies";
    homepage = "http://linuxstopmotion.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "stopmotion";
  };
}
