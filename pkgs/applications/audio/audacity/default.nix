{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib }:

stdenv.mkDerivation {
  name = "audacity-1.3.7";

  NIX_CFLAGS_COMPILE = "-fPIC -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0 -lz";

  src = fetchurl {
    url = mirror://sourceforge/audacity/audacity-fullsrc-1.3.7.tar.bz2;
    sha256 = "1kashc6cc6d5g6i59nqcrl795x1jqdh0lpg3msa1wckfj3hpljmy";
  };
  buildInputs = [ wxGTK pkgconfig gettext gtk glib zlib ];

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
  };
}
