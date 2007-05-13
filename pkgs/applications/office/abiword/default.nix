{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt
}:

stdenv.mkDerivation {
  name = "abiword-2.4.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.4.6/source/abiword-2.4.6.tar.gz;
    sha256 = "1lzyl9nd545jga1hh5c67kdqajp60i5xc67wvg6jcgzkn41my44q";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt
                ];
}
