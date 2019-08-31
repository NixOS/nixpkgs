{ stdenv, fetchurl, docbook_xsl, dbus, dbus-glib, expat
, gsettings-desktop-schemas, gdk-pixbuf, gtk3, hicolor-icon-theme
, imagemagick, itstool, librsvg, libtool, libxslt, makeWrapper
, pkgconfig, python, pythonPackages, vte
, wrapGAppsHook}:

# TODO: Still getting following warning.
# WARNING **: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files
# Seems related to this:
# https://forums.gentoo.org/viewtopic-t-947210-start-0.html

let version = "3.3.2";
in stdenv.mkDerivation rec {
  pname = "roxterm";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/roxterm/${pname}-${version}.tar.xz";
    sha256 = "0vjh7k4jm4bd01j88w9bmvq27zqsajjzy131fpi81zkii5lisl1k";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs =
    [ docbook_xsl expat imagemagick itstool librsvg libtool libxslt
      makeWrapper python pythonPackages.lockfile dbus dbus-glib
      gdk-pixbuf gsettings-desktop-schemas gtk3
      hicolor-icon-theme vte ];

  NIX_CFLAGS_COMPILE = [ "-I${dbus-glib.dev}/include/dbus-1.0"
                         "-I${dbus.dev}/include/dbus-1.0"
                         "-I${dbus.lib}/lib/dbus-1.0/include" ];

  # Fix up python path so the lockfile library is on it.
  PYTHONPATH = stdenv.lib.makeSearchPathOutput "lib" python.sitePackages [
    pythonPackages.lockfile
  ];

  buildPhase = ''
    # Fix up the LD_LIBRARY_PATH so that expat is on it
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${expat.out}/lib"

    python mscript.py configure --prefix="$out" --disable-nls --disable-translations
    python mscript.py build
  '';

  installPhase = ''
    python mscript.py install
  '';

  meta = with stdenv.lib; {
    homepage = http://roxterm.sourceforge.net/;
    license = licenses.gpl3;
    description = "Tabbed, VTE-based terminal emulator";
    longDescription = ''
      Tabbed, VTE-based terminal emulator. Similar to gnome-terminal without
      the dependencies on Gnome.
    '';
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
