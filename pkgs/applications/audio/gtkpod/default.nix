{ stdenv, fetchurl, pkgconfig, libgpod, gtk, glib, gettext, perl, perlXMLParser
, libglade, flex, libid3tag, libvorbis, intltool }:

stdenv.mkDerivation {
  name = "gtkpod-1.0.0";

  src = fetchurl {
    url = mirror://sourceforge/gtkpod/gtkpod-1.0.0.tar.gz;
    sha256 = "04jzybs55c27kyp7r9c58prcq0q4ssvj5iggva857f49s1ar826q";
  };

  buildInputs = [ pkgconfig libgpod gettext perl perlXMLParser gtk libglade flex
    libid3tag libvorbis intltool ];

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  meta = {
    description = "GTK Manager for an Apple ipod";
    homepage = http://gtkpod.sourceforge.net;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
