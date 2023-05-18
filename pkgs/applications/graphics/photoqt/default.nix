{ mkDerivation, lib, fetchurl, cmake, exiv2, graphicsmagick, libraw
, qtbase, qtdeclarative, qtmultimedia, qtquickcontrols2, qttools, qtgraphicaleffects
, extra-cmake-modules, poppler, kimageformats, libarchive, pugixml, wrapQtAppsHook}:

mkDerivation rec {
  pname = "photoqt";
  version = "3.1";

  src = fetchurl {
    url = "https://${pname}.org/pkgs/${pname}-${version}.tar.gz";
    hash = "sha256-hihfqE7XIlSAxPg3Kzld3LrYS97wDH//GGqpBpBwFm0=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules qttools wrapQtAppsHook ];

  buildInputs = [
    qtbase qtquickcontrols2 exiv2 graphicsmagick poppler
    qtmultimedia qtdeclarative libraw qtgraphicaleffects
    kimageformats libarchive pugixml
  ];

  cmakeFlags = [
    "-DFREEIMAGE=OFF"
    "-DDEVIL=OFF"
    "-DCHROMECAST=OFF"
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  meta = {
    homepage = "https://photoqt.org/";
    description = "Simple, yet powerful and good looking image viewer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
