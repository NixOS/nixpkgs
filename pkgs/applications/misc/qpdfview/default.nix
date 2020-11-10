{stdenv, mkDerivation, fetchurl, qmake, qtbase, qtsvg, pkgconfig, poppler, djvulibre, libspectre, cups
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
  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [
    qtbase qtsvg poppler djvulibre libspectre cups file ghostscript
  ];
in
mkDerivation {
  pname = s.baseName;
  inherit (s) version;
  inherit nativeBuildInputs buildInputs;
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
    updateWalker = true;
  };
}
