{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.4";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.4/source/abiword-2.8.4.tar.gz;
    sha256 = "1v2f83cc8j6chsyzgjh903s6c8fkr7dy5s10bqigzfrqi9iv990l";
  };

  buildInputs = [pkgconfig gtk libglade librsvg bzip2
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
