{lib, mkDerivation, fetchurl, qmake, qtbase, qtsvg, pkg-config, poppler, djvulibre, libspectre, cups
, file, ghostscript
}:
let
  s = # Generated upstream information
  rec {
    baseName="qpdfview";
    version = "0.4.18";
    name="${baseName}-${version}";
    url="https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-${version}.tar.gz";
    sha256 = "0v1rl126hvblajnph2hkansgi0s8vjdc5yxrm4y3faa0lxzjwr6c";
  };
  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    qtbase qtsvg poppler djvulibre libspectre cups file ghostscript
  ];
  # apply upstream fix for qt5.15 https://bazaar.launchpad.net/~adamreichold/qpdfview/trunk/revision/2104
  patches = [ ./qpdfview-qt515-compat.patch ];
in
mkDerivation {
  pname = s.baseName;
  inherit (s) version;
  inherit nativeBuildInputs buildInputs patches;
  src = fetchurl {
    inherit (s) url sha256;
  };

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

  meta = {
    inherit (s) version;
    description = "A tabbed document viewer";
    license = lib.licenses.gpl2Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
    updateWalker = true;
  };
}
