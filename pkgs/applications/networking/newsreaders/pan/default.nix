{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext
}:

assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.129";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.129/source/pan-0.129.tar.bz2;
    sha256 = "07hv304bq65lpa3442i6xi621lrcxw5mzb09xw57dyvx6kb20sf8";
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
