{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext
}:

assert spellChecking -> gtkspell != null;

stdenv.mkDerivation {
  name = "pan-0.133";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.133/source/pan-0.133.tar.bz2;
    sha1 = "a0bd98ea1ba174800896611e3305a6b6d8dbde2f";
  };

  buildInputs = [pkgconfig gtk perl pcre gmime gettext]
    ++ stdenv.lib.optional spellChecking gtkspell;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
    homepage = http://pan.rebelbase.com/;
  };
}
