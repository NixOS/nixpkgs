{stdenv, fetchurl, pkgconfig, glib, gtk, pango
, libglade, libgnomeprint, libgnomeprintui, libgnomecanvas
, fribidi, libpng, popt
}:

stdenv.mkDerivation {
  name = "abiword-2.4.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.4.5/source/abiword-2.4.5.tar.gz;
    md5 = "e05f15936535c4b737deaa721adf8d09";
  };

  buildInputs = [pkgconfig glib gtk pango libglade libgnomeprint
                 libgnomeprintui libgnomecanvas fribidi libpng popt
                ];
}
