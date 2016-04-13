{ stdenv, fetchurl, docbook_xsl, dbus_libs, dbus_glib, expat, gettext
, gsettings_desktop_schemas, gdk_pixbuf, gtk2, gtk3, hicolor_icon_theme
, imagemagick, itstool, librsvg, libtool, libxslt, lockfile, makeWrapper
, pkgconfig, pythonFull, pythonPackages, vte }:

# TODO: Still getting following warning.
# WARNING **: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files
# Seems related to this:
# https://forums.gentoo.org/viewtopic-t-947210-start-0.html

let version = "2.9.4";
in stdenv.mkDerivation rec {
  name = "roxterm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/roxterm/${name}.tar.bz2";
    sha256 = "0djfiwfmnqqp6930kswzr2rss0mh40vglcdybwpxrijcw4n8j21x";
  };

  buildInputs =
    [ docbook_xsl expat imagemagick itstool librsvg libtool libxslt
      makeWrapper pkgconfig pythonFull pythonPackages.lockfile ];

  propagatedBuildInputs =
    [ dbus_libs dbus_glib gdk_pixbuf gettext gsettings_desktop_schemas gtk2 gtk3 hicolor_icon_theme vte ];

  NIX_CFLAGS_COMPILE = [ "-I${dbus_glib.dev}/include/dbus-1.0"
                         "-I${dbus_libs.dev}/include/dbus-1.0"
                         "-I${dbus_libs.lib}/lib/dbus-1.0/include" ];

  # Fix up python path so the lockfile library is on it.
  PYTHONPATH = stdenv.lib.makeSearchPathOutputs pythonFull.sitePackages ["lib"] [
    pythonPackages.curses pythonPackages.lockfile
  ];

  buildPhase = ''
    # Fix up the LD_LIBRARY_PATH so that expat is on it
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${expat.out}/lib"

    python mscript.py configure --prefix="$out"
    python mscript.py build
  '';

  installPhase = ''
    python mscript.py install

    wrapProgram "$out/bin/roxterm" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    homepage = http://roxterm.sourceforge.net/;
    license = licenses.gpl3;
    description = "Tabbed, VTE-based terminal emulator";
    longDescription = ''
      Tabbed, VTE-based terminal emulator.  Similar to gnome-terminal without the dependencies on Gnome.
    '';
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
