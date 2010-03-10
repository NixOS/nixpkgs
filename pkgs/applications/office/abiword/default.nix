{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv, librsvg, bzip2
}:

stdenv.mkDerivation {
  name = "abiword-2.8.2";
  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.2/source/abiword-2.8.2.tar.gz;
    sha256 = "176v0c41453qspz958s9jlsbh1sdg61j7cpdp86x93lsci3qyrnb";
  };

  buildInputs = [pkgconfig gtk libglade librsvg bzip2
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
