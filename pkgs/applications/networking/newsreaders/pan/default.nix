{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext
}:

assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.128";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.128/source/pan-0.128.tar.bz2;
    sha1 = "3fca3cbd3d3ae3cc507d2b0a06a0fe03c993abe6";
  };

  buildInputs = [
    pkgconfig gtk perl pcre gmime gettext
    (if spellChecking then gtkspell else null)
  ];

  inherit spellChecking stdenv;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
  };
}
