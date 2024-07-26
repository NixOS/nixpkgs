{ lib
, mkDerivation
, fetchurl
, qmake
, qtbase
, qttools
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
  version = "0.5.0";

  src = fetchurl {
    url = "https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-0.5.tar.gz";
    hash = "sha256-RO/EQKRhy911eps5bxRh7novQ2ToHfVb0CIfkQIZvpk=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
  ];

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
    lrelease qpdfview.pro
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

  env = {
    # Fix build due to missing `std::option`.
    NIX_CFLAGS_COMPILE = "-std=c++17";
  };

  meta = with lib; {
    description = "Tabbed document viewer";
    mainProgram = "qpdfview";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
  };
}
