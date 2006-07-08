{stdenv, fetchurl, pkgconfig, glib, gtk, pango
, libglade, libgnomeprint, libgnomeprintui, libgnomecanvas
, fribidi, libpng, popt
}:

stdenv.mkDerivation {
  name = "abiword-2.4.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.4.4/source/abiword-2.4.4.tar.gz;
    md5 = "5a2710c2ed89608f30fa8dbed001719c";
  };

  buildInputs = [pkgconfig glib gtk pango libglade libgnomeprint
                 libgnomeprintui libgnomecanvas fribidi libpng popt
                ];
}
