{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL
}:

assert pkgconfig != null && gtk != null && perl != null
  && zip != null && libIDL != null;

assert libIDL.glib == gtk.glib;

derivation {
  name = "firefox-0.8";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/0.8/firefox-source-0.8.tar.bz2;
    md5 = "cdc85152f4219bf3e3f1a8dc46e04654";
  };

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gtk = gtk;
  perl = perl;
  zip = zip;
  libIDL = libIDL;
}
