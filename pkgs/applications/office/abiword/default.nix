{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.5";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.5/source/abiword-2.8.5.tar.gz;
    sha256 = "0k82y1wd2lx4ifk8rbifbr301zqnrbx61b7x78b14n4k8x13srxa";
  };

  buildInputs = [pkgconfig gtk libglade librsvg bzip2
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
