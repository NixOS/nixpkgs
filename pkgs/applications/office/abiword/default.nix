{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv
}:

stdenv.mkDerivation {
  name = "abiword-2.6.6";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.6.6/source/abiword-2.6.6.tar.gz;
    sha256 = "1cgi6l3wd82vgni4wcqasyl2rvxwffliyqgbwvzv0nn99wasg5gx";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
