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
  name = "inkscape-0.42.2";

  src = fetchurl {
    url = http://easynews.dl.sourceforge.net/sourceforge/inkscape/inkscape-0.42.2.tar.bz2;
    md5 = "a27172087018e850e92e97e52b5dad08";
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
