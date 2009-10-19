{ stdenv, fetchurl, pkgconfig, libgpod, gtk, glib, gettext, perl, perlXMLParser, libglade, flex, libid3tag, libvorbis }:

stdenv.mkDerivation {
  name = "gtkpod-0.99.14";

  src = fetchurl {
    url = mirror://sourceforge/gtkpod/gtkpod-0.99.14.tar.gz;
    sha256 = "0ggcfyhcdlf3br88csdki215k4clxixa192afz6f16k7h8s2iqbk";
  };

  buildInputs = [ pkgconfig libgpod gettext perl perlXMLParser gtk libglade flex libid3tag libvorbis ];

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  meta = {
    description = "GTK Manager for an Apple ipod";
    homepage = http://gtkpod.sourceforge.net;
    license = "GPLv2+";
  };
}
