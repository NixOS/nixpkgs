{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert !isNull pkgconfig && !isNull gtk && !isNull png;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
assert libpng == gtk.libpng;

derivation {
  name = "gqview-1.3.5";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-1.3.5.tar.gz;
    md5 = "c44687bdd636ea6e5133fb936abf880a";
  };

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gtk = gtk;
  libpng = libpng;
}
