{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad
  }:

stdenv.mkDerivation {
  name = "audacity-1.3.7";

  NIX_CFLAGS_COMPILE = "-fPIC -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0 -lz";

  src = fetchurl {
    url = mirror://sourceforge/audacity/audacity-fullsrc-1.3.7.tar.bz2;
    sha256 = "0b4arafpdyjjk52l6n7aw518hzm65iv9w5g39jqr2bmvn6a9qivi";
  };
  buildInputs = [ wxGTK pkgconfig gettext gtk glib zlib intltool perl 
    libogg libvorbis libmad];

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
  };
}
