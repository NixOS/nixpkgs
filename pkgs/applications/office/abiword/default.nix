{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.3";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.3/source/abiword-2.8.3.tar.gz;
    sha256 = "1jz3w1rp5wyhv2sk62r14kxljcd3x9kf4axm3zfjaqifhnjpnkxp";
  };

  buildInputs = [pkgconfig gtk libglade librsvg bzip2
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
