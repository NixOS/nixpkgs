{ stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.6";
  
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz;
    sha256 = "059sd2apxdmcacc4pll880i7vm18h0kyjsq299m1mz3c7ak8k46r";
  };

  buildInputs =
    [ pkgconfig gtk libglade librsvg bzip2 libgnomecanvas fribidi libpng popt
      libgsf enchant wv
    ];
}
