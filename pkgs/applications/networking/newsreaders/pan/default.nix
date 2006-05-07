{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null, gnet
, perl, pcre, gmime, gettext
}:

assert pkgconfig != null && gtk != null && gnet != null
  && perl != null && pcre != null;
assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.96";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.96/SOURCE/pan-0.96.tar.bz2;
    md5 = "b4e355553cd502add3e599d1e867da9e";
  };

  buildInputs = [
    pkgconfig gtk gnet perl pcre gmime gettext
    (if spellChecking then gtkspell else null)
  ];

  inherit spellChecking stdenv;
}
