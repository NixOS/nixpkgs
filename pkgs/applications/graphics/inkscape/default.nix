{ stdenv, fetchurl, pkgconfig,
  perl, perlXMLParser,
  gtk, libXft, fontconfig,
  libpng,
  zlib, popt,
  boehmgc,
  libxml2, libxslt,
  glib,
  gtkmm, glibmm, libsigcxx
}:

stdenv.mkDerivation {
  name = "inkscape-0.43";

  src = fetchurl {
    url = mirror://sourceforge/inkscape/inkscape-0.43.tar.bz2;
    md5 = "97c606182f5e177eef70c1e8a55efc1f";
  };

  buildInputs = [
    pkgconfig
    perl perlXMLParser
    gtk libXft fontconfig
    libpng
    zlib popt
    boehmgc
    libxml2 libxslt
    glib
    gtkmm glibmm libsigcxx
  ];
}
