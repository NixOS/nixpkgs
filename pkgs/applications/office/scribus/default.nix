{ stdenv, fetchurl, pkgconfig, freetype, lcms, libtiff, libxml2
, libart_lgpl, qt4, python, cups, fontconfig, libjpeg
, zlib, libpng, xorg, cairo, podofo, aspell, boostHeaders, cmake }:

stdenv.mkDerivation rec {
  name = "scribus-1.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/scribus/scribus/${name}.tar.xz";
    sha256 = "1zxgl2g299rllfy5ihs5skicpv7zcmz149ahraami69gqcag6bn7";
  };

  enableParallelBuilding = true;

  buildInputs = with xorg;
    [ pkgconfig cmake freetype lcms libtiff libxml2 libart_lgpl qt4
      python cups fontconfig
      libjpeg zlib libpng podofo aspell cairo
      boostHeaders # for internal 2geom library
      libXaw libXext libX11 libXtst libXi libXinerama
      libpthreadstubs libXau libXdmcp
    ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = http://www.scribus.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
