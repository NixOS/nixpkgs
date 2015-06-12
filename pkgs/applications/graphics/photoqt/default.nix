{ stdenv, fetchurl, cmake, qt5, exiv2, graphicsmagick }:

let
  version = "1.2";
in
stdenv.mkDerivation rec {
  name = "photoqt-${version}";
  src = fetchurl {
    url = "http://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    sha256 = "1dnnj2h3j517hcbjxlzk035fis44wdmqq7dvhwpmq1rcr0v32aaa";
  };

  buildInputs = [ cmake qt5.base qt5.tools exiv2 graphicsmagick ];

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
