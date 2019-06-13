{ stdenv, fetchurl, cmake, exiv2, graphicsmagick, libraw
, qtbase, qtdeclarative, qtmultimedia, qtquickcontrols, qttools, qtgraphicaleffects
}:

stdenv.mkDerivation rec {
  name = "photoqt-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "https://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    sha256 = "17kkpzkmzfnigs26jjyd75iy58qffjsclif81cmviq73lzmqy0b1";
  };

  patches = [ ./photoqt-1.5.1-qt-5.9.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qtbase qtquickcontrols qttools exiv2 graphicsmagick
    qtmultimedia qtdeclarative libraw qtgraphicaleffects
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://photoqt.org/;
    description = "Simple, yet powerful and good looking image viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
