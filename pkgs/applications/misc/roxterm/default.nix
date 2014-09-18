{ stdenv, fetchurl, docbook_xsl, dbus_libs, dbus_glib, expat, gettext, gsettings_desktop_schemas, gdk_pixbuf, gtk2, gtk3, hicolor_icon_theme, imagemagick, itstool, librsvg, libtool, libxslt, lockfile, makeWrapper, pkgconfig, pythonFull, pythonPackages, vte }:

# TODO: Still getting following warning:
# Gtk-WARNING **: Error loading icon from file '/nix/store/36haql12nc3c91jqf0w8nz29zrwxd2gl-roxterm-2.9.4/share/icons/hicolor/scalable/apps/roxterm.svg':
# Couldn't recognize the image file format for file '/nix/store/36haql12nc3c91jqf0w8nz29zrwxd2gl-roxterm-2.9.4/share/icons/hicolor/scalable/apps/roxterm.svg'

stdenv.mkDerivation rec {

  versionMajor = "2.9";
  versionMinor = "4";

  name = "roxterm-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/roxterm/${name}.tar.bz2";
    sha256 = "0djfiwfmnqqp6930kswzr2rss0mh40vglcdybwpxrijcw4n8j21x";
  };

  buildInputs = [ docbook_xsl expat imagemagick itstool librsvg libtool libxslt makeWrapper pkgconfig pythonFull pythonPackages.lockfile ];

  propagatedBuildInputs = [ dbus_libs dbus_glib gdk_pixbuf gettext gsettings_desktop_schemas gtk2 gtk3 hicolor_icon_theme vte ];

  NIX_CFLAGS_COMPILE = [ "-I${dbus_glib}/include/dbus-1.0"
                         "-I${dbus_libs}/include/dbus-1.0"
                         "-I${dbus_libs}/lib/dbus-1.0/include" ];

  ldLibraryPath = "${expat}/lib"; # ugly hack for xgettext to work during build

  pythonPath = [ pythonPackages.curses pythonPackages.lockfile ];

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    homepage = http://roxterm.sourceforge.net/;
	license = licenses.gpl3;
	description = "Tabbed, VTE-based terminal emulator";
	longDescription = ''
	  Tabbed, VTE-based terminal emulator.  Similar to gnome-terminal without the dependencies on Gnome.
	'';
    platforms = platforms.linux;
  };
}
