{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.1";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.1/source/abiword-2.8.1.tar.gz;
    sha256 = "1v6jkjd5ivaarhv41nkniqycx3k33p9r7q7dyyjn7kq2295n26zm";
  };

  buildInputs = [pkgconfig gtk libglade librsvg bzip2
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
