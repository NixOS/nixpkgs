{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  qt5,
  libvorbis,
  libtar,
  libxml2,
}:

stdenv.mkDerivation rec {
  version = "0.8.5";
  pname = "stopmotion";

  src = fetchgit {
    url = "https://git.code.sf.net/p/linuxstopmotion/code";
    rev = version;
    sha256 = "1612lkwsfzc59wvdj2zbj5cwsyw66bwn31jrzjrxvygxdh4ab069";
  };

  nativeBuildInputs = [
    qt5.qmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtmultimedia
    libvorbis
    libtar
    libxml2
  ];

  postPatch = ''
    substituteInPlace stopmotion.pro --replace '$$[QT_INSTALL_BINS]' '${lib.getDev qt5.qttools}/bin'
  '';

  meta = with lib; {
    description = "Create stop-motion animation movies";
    homepage = "http://linuxstopmotion.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "stopmotion";
  };
}
