{ stdenv, fetchurl, pkgconfig, gtk3, libglade, libgnomecanvas, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg, perl
, boost, libxslt
}:

stdenv.mkDerivation rec {
  name = "abiword-${version}";
  version = "3.0.1";

  src = fetchurl {
    url = "http://www.abisource.org/downloads/abiword/${version}/source/${name}.tar.gz";
    sha256 = "1ik591rx15nn3n1297cwykl8wvrlgj78i528id9wbidgy3xzd570";
  };

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig gtk3 libglade librsvg bzip2 libgnomecanvas fribidi libpng popt
      libgsf enchant wv libjpeg perl boost libxslt
    ];

  meta = with stdenv.lib; {
    description = "Word processing program, similar to Microsoft Word";
    homepage = http://www.abisource.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
