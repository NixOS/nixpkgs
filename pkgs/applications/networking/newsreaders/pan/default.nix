{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null, gnet
, libxml2, perl, pcre
}:

assert !isNull pkgconfig && !isNull gtk && !isNull gnet
  && !isNull libxml2 && !isNull perl && !isNull pcre;
assert spellChecking -> !isNull gtkspell && gtk == gtkspell.gtk;
assert gtk.glib == gnet.glib;

derivation {
  name = "pan-0.14.2.90";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.14.2.90/SOURCE/pan-0.14.2.90.tar.bz2;
    md5 = "03e6d936254e775a94995ba261be23eb";
  };

  spellChecking = spellChecking;

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gtk = gtk;
  gtkspell = if spellChecking then gtkspell else null;
  gnet = gnet;
  libxml2 = libxml2;
  perl = perl;
  pcre = pcre;
}
