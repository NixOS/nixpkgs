{stdenv, fetchurl, pkgconfig, glib, perl}:

assert !isNull pkgconfig && !isNull glib && !isNull perl;

derivation {
  name = "atk-1.2.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.2/atk-1.2.4.tar.bz2;
    md5 = "2d6d50df31abe0e8892b5d3e7676a02d";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  glib = glib;
  perl = perl;
}
