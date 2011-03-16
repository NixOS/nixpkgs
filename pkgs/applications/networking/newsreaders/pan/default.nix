{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext, intltool
}:

assert spellChecking -> gtkspell != null;

let version = "0.134"; in

stdenv.mkDerivation {
  name = "pan-${version}";

  src = fetchurl {
    url = "http://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha1 = "7ef9385e59edf7d511ad3de6c39482297c820685";
  };

  buildInputs = [ pkgconfig gtk perl gmime gettext intltool ]
    ++ stdenv.lib.optional spellChecking gtkspell;

  enableParallelBuilding = true;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
    homepage = http://pan.rebelbase.com/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
