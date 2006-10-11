{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null, gnet
, perl, pcre, gmime, gettext
}:

assert pkgconfig != null && gtk != null && gnet != null
  && perl != null && pcre != null;
assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.106";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.106/SOURCE/pan-0.106.tar.bz2;
    md5 = "34cdc4b7606f09517f015a2c624044c9";
  };

  buildInputs = [
    pkgconfig gtk gnet perl pcre gmime gettext
    (if spellChecking then gtkspell else null)
  ];

  inherit spellChecking stdenv;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
  };
}
