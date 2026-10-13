{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsForQt5,
  djvulibre,
  libspectre,
  cups,
  file,
  ghostscript,
}:

stdenv.mkDerivation rec {
  pname = "qpdfview";
  version = "0.5.0";

  src = fetchurl {
    url = "https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-0.5.tar.gz";
    hash = "sha256-RO/EQKRhy911eps5bxRh7novQ2ToHfVb0CIfkQIZvpk=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.poppler
    djvulibre
    libspectre
    cups
    file
    ghostscript
  ];

  # needed for qmakeFlags+=( below
  __structuredAttrs = true;

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

  meta = {
    description = "Tabbed document viewer";
    mainProgram = "qpdfview";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
  };
}
