{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv
}:

stdenv.mkDerivation {
  name = "abiword-2.6.3";
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.6.0/source/abiword-2.6.3.tar.gz;
    sha256 = "1v4hvnlf5x9q4w3w4yvv712hsajmhv8dpndbni623ag24g2frzz5";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
