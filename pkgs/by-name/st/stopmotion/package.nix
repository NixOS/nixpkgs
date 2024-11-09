{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  qt5,
  libvorbis,
  libarchive,
  libxml2,
}:

stdenv.mkDerivation rec {
  version = "0.8.7";
  pname = "stopmotion";

  src = fetchgit {
    url = "https://invent.kde.org/multimedia/stopmotion";
    rev = version;
    hash = "sha256-wqrB0mo7sI9ntWF9QlYmGiRiIoLkMzD+mQ6BzhbAKX8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtmultimedia
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
