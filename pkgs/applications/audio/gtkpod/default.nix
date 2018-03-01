{ stdenv, fetchurl, pkgconfig, makeWrapper, intltool, libgpod, curl, flac,
  gnome, gtk3, glib, gettext, perl, perlXMLParser, flex, libglade, libid3tag,
  libvorbis, hicolor-icon-theme, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "2.1.5";
  name = "gtkpod-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.gz";
    sha256 = "0xisrpx069f7bjkyc8vqxb4k0480jmx1wscqxr6cpq1qj6pchzd5";
  };

  propagatedUserEnvPkgs = [ gnome.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper intltool curl gettext perl perlXMLParser
    flex libgpod libid3tag flac libvorbis gtk3 gdk_pixbuf libglade gnome.anjuta
    gnome.gdl gnome.defaultIconTheme
    hicolor-icon-theme ];

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  preFixup = ''
    wrapProgram "$out/bin/gtkpod" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome.gnome-themes-standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
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
