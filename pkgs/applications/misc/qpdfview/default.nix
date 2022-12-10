{ lib
, mkDerivation
, fetchurl
, qmake
, qtbase
, qtsvg
, pkg-config
, poppler
, djvulibre
, libspectre
, cups
, file
, ghostscript
}:
mkDerivation rec {
  pname = "qpdfview";
  version = "0.4.18";

  src = fetchurl {
    url = "https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-${version}.tar.gz";
    sha256 = "0v1rl126hvblajnph2hkansgi0s8vjdc5yxrm4y3faa0lxzjwr6c";
  };

  # apply upstream fix for qt5.15 https://bazaar.launchpad.net/~adamreichold/qpdfview/trunk/revision/2104
  patches = [ ./qpdfview-qt515-compat.patch ];

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    qtbase
    qtsvg
    poppler
    djvulibre
    libspectre
    cups
    file
    ghostscript
  ];
  preConfigure = ''
    qmakeFlags+=(*.pro)
  '';

  qmakeFlags = [
    "TARGET_INSTALL_PATH=${placeholder "out"}/bin"
    "PLUGIN_INSTALL_PATH=${placeholder "out"}/lib/qpdfview"
    "DATA_INSTALL_PATH=${placeholder "out"}/share/qpdfview"
    "MANUAL_INSTALL_PATH=${placeholder "out"}/share/man/man1"
    "ICON_INSTALL_PATH=${placeholder "out"}/share/icons/hicolor/scalable/apps"
    "LAUNCHER_INSTALL_PATH=${placeholder "out"}/share/applications"
    "APPDATA_INSTALL_PATH=${placeholder "out"}/share/appdata"
  ];

  meta = with lib; {
    description = "A tabbed document viewer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
  };
}
