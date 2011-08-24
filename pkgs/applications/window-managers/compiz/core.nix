{ stdenv, fetchurl, intltool, pkgconfig, xlibs, mesa, libxml2, libxslt
, libstartup_notification, libpng, glib, gtk, gnome, dbus_glib, librsvg, bzip2 }:

let version = "0.8.6"; in

stdenv.mkDerivation {
  name = "compiz-${version}";

  src = fetchurl {
    url = "http://releases.compiz.org/${version}/compiz-${version}.tar.bz2";
    sha256 = "132gmdawjmrmvazm31h3r3wwq97h58hz17yyc9sa6q2nkfsnkpy4";
  };

  patches =
    [ # Allow the path to the Compiz plugin library and metadata
      # directories to be overriden through $COMPIZ_PLUGINDIR and
      # $COMPIZ_METADATADIR, respectively.
      ./plugindir-core.patch

      # Fix compilation with recent GTK versions.
      ./gdk-deprecated.patch
    ];

  buildInputs =
    [ intltool pkgconfig libpng glib
      gtk gnome.libwnck gnome.GConf dbus_glib librsvg bzip2
    ];

  propagatedBuildInputs =
    [ xlibs.xlibs xlibs.libXfixes xlibs.libXrandr xlibs.libXrender
      xlibs.libXdamage xlibs.libXcomposite xlibs.libXinerama
      libstartup_notification mesa libxml2 libxslt 
    ];

  meta = {
    homepage = http://www.compiz.org/;
    description = "A compositing window manager";
    platforms = stdenv.lib.platforms.linux;
  };
}
