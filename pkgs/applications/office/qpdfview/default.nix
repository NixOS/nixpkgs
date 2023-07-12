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
  version = "0.5.0";

  src = fetchurl {
    url = "https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-0.5.tar.gz";
    hash = "sha256-RO/EQKRhy911eps5bxRh7novQ2ToHfVb0CIfkQIZvpk=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtsvg
    # Until qpdfview builds with latest poppler
    (poppler.overrideAttrs
      (old: {
        version = "23.02.0";
        src = fetchurl {
          url = "https://poppler.freedesktop.org/poppler-23.02.0.tar.xz";
          hash = "sha256-MxXdonD+KzXPH0HSdZSMOWUvqGO5DeB2b2spPZpVj8k=";
        };
      }))
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
