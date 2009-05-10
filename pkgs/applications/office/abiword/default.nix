{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv
}:

stdenv.mkDerivation {
  name = "abiword-2.6.8";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.6.8/source/abiword-2.6.8.tar.gz;
    sha256 = "14vfp668srjgy6wd22h4a93safp1iyfwhdr6y0sb751xl46nlrdn";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
