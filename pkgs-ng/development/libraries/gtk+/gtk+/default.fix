{ stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng}:

assert !isNull pkgconfig && !isNull x11 && !isNull glib && !isNull atk
  && !isNull pango && !isNull perl && !isNull perl && !isNull libtiff
  && !isNull libjpeg && !isNull libpng;
assert x11.buildClientLibs;
assert glib == atk.glib;
assert glib == pango.glib;
assert x11 == pango.x11;

derivation {
  name = "gtk+-2.2.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.2/gtk+-2.2.4.tar.bz2;
    md5 = "605332199533e73bc6eec481fb4f1671";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  x11 = x11;
  glib = glib;
  atk = atk;
  pango = pango;
  perl = perl;
  libtiff = libtiff;
  libjpeg = libjpeg;
  libpng = libpng;
}
