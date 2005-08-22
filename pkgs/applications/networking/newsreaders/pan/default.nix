{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null, gnet
, libxml2, perl, pcre
}:

assert pkgconfig != null && gtk != null && gnet != null
  && libxml2 != null && perl != null && pcre != null;
assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.14.2.91";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pan-0.14.2.91.tar.bz2;
    md5 = "4770d899a1c1ba968ce96bc5aeb07b62";
  };

  buildInputs = [
    pkgconfig gtk gnet libxml2 perl pcre
    (if spellChecking then gtkspell else null)
  ];

  inherit spellChecking stdenv;
}
