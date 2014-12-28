{ stdenv, fetchurl, cmake, qt5, exiv2, graphicsmagick }:

let
  version = "1.1.0.1";
in
stdenv.mkDerivation rec {
  name = "photoqt-${version}";
  src = fetchurl {
    url = "http://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    sha256 = "1y59ys1dgjppahs7v7kxwva7ik23s0x7j2f6glv6sn23l9cfq9rp";
  };

  buildInputs = [ cmake qt5 exiv2 graphicsmagick ];

  patches = [ ./graphicsmagick-path.patch ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  meta = {
    homepage = "http://photoqt.org/";
    description = "Simple, yet powerful and good looking image viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
