{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL
}:

assert !isNull pkgconfig && !isNull gtk && !isNull perl
  && !isNull zip && !isNull libIDL;

assert libIDL.glib == gtk.glib;

derivation {
  name = "MozillaFirebird-0.7";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.mozilla.org/pub/mozilla.org/firebird/releases/0.7/MozillaFirebird-source-0.7.tar.gz;
    md5 = "35112566a3dca5bdf363972056afc462";
  };

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gtk = gtk;
  perl = perl;
  zip = zip;
  libIDL = libIDL;
}
