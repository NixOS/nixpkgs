{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null, gnet, libxml2, perl
}:

assert !isNull pkgconfig && !isNull gtk && !isNull gnet
  && !isNull libxml2 && !isNull perl;
assert spellChecking -> !isNull gtkspell && gtk == gtkspell.gtk;
assert gtk.glib == gnet.glib;

derivation {
  name = "pan-0.14.2";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.14.2/SOURCE/pan-0.14.2.tar.bz2;
    md5 = "ed3188e7059bb6d6c209ee5d46ac1852";
  };

  spellChecking = spellChecking;

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gtk = gtk;
  gtkspell = if spellChecking then gtkspell else null;
  gnet = gnet;
  libxml2 = libxml2;
  perl = perl;
}
