{ stdenv, fetchurl, pkgconfig, freetype, lcms, libtiff, libxml2
, libart_lgpl, qt4, python, cups, fontconfig, libjpeg
, zlib, libpng, xorg, cairo, podofo, aspell, boost, cmake }:

stdenv.mkDerivation rec {
  name = "scribus-1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/scribus/scribus/${name}.tar.xz";
    sha256 = "16m1g38dig37ag0zxjx3wk1rxx9xxzjqfc7prj89rp4y1m83dqr1";
  };

  enableParallelBuilding = true;

  buildInputs = with xorg;
    [ pkgconfig cmake freetype lcms libtiff libxml2 libart_lgpl qt4
      python cups fontconfig
      libjpeg zlib libpng podofo aspell cairo
      boost # for internal 2geom library
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
