{ stdenv, fetchurl, pkgconfig, freetype, lcms, libtiff, libxml2
, libart_lgpl, qt, python, cups, fontconfig, libjpeg
, zlib, libpng, xorg, cairo, podofo, aspell, boost, cmake }:
stdenv.mkDerivation {
  name = "scribus-1.4.0rc6";

  src = fetchurl {
    url = mirror://sourceforge/scribus/scribus/scribus-1.4.0.rc6.tar.bz2;
    sha256 = "1rrnzxjzhqj4lgyfswly501xlyvm4hsnnq7zw008v0cnkx31icli";
  };

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig cmake freetype lcms libtiff libxml2 libart_lgpl qt
      python cups fontconfig
      xorg.libXaw xorg.libXext xorg.libX11 xorg.libXtst xorg.libXi xorg.libXinerama
      libjpeg zlib libpng podofo aspell cairo
    ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = http://www.scribus.net;
    license = "GPLv2";
  };
}
