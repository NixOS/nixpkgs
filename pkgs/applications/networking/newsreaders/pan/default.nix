{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext
}:

assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.130";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.130/source/pan-0.130.tar.bz2;
    sha1 = "158d1e599fcae2a25431ec5a74a105149bae19b1";
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
