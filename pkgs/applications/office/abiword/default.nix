{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv
}:

stdenv.mkDerivation {
  name = "abiword-2.6.0";
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.6.0/source/abiword-2.6.0.tar.gz;
    sha256 = "1fzhfk3bbv65bj9rifhzki57mpsvz4mw89ic3jl0d1zdgg8cxc9m";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
