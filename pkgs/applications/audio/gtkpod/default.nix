{ stdenv, fetchurl, pkgconfig, wrapGAppsHook, intltool, libgpod, curl, flac,
  gnome3, gtk3, glib, gettext, perl, perlXMLParser, flex, libid3tag,
  libvorbis, hicolor-icon-theme, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "2.1.5";
  name = "gtkpod-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.gz";
    sha256 = "0xisrpx069f7bjkyc8vqxb4k0480jmx1wscqxr6cpq1qj6pchzd5";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool ];
  buildInputs = [
    curl gettext perl perlXMLParser
    flex libgpod libid3tag flac libvorbis gtk3 gdk_pixbuf
    gnome3.gdl gnome3.defaultIconTheme gnome3.anjuta
  ];

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GTK Manager for an Apple ipod";
    homepage = http://gtkpod.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.skeidel ];
  };
}
