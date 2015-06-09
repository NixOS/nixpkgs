{ stdenv, fetchurl, pkgconfig, makeWrapper, intltool, libgpod, curl, flac,
  gnome, gtk3, glib, gettext, perl, perlXMLParser, flex, libglade, libid3tag,
  libvorbis, hicolor_icon_theme, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "2.1.4";
  name = "gtkpod-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.gz";
    sha256 = "ba12b35f3f24a155b68f0ffdaf4d3c5c7d1b8df04843a53306e1c83fc811dfaa";
  };

  propagatedUserEnvPkgs = [ gnome.gnome_themes_standard ];

  buildInputs = [ pkgconfig makeWrapper intltool curl gettext perl perlXMLParser
    flex libgpod libid3tag flac libvorbis gtk3 gdk_pixbuf libglade gnome.anjuta
    gnome.gdl gnome.defaultIconTheme
    hicolor_icon_theme ];

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  preFixup = ''
    wrapProgram "$out/bin/gtkpod" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
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
