{ stdenv, fetchurl, pkgconfig, pidgin, libnotify, gdk_pixbuf, glib, dbus
, dbus_glib }:

stdenv.mkDerivation rec {
  name = "skype4pidgin-novas0x2a-20120411-6c53f7c48f";
  src = fetchurl {
    url = "https://github.com/novas0x2a/skype4pidgin/tarball/6c53f7c48f";
    name = "${name}.tar.gz";
    sha256 = "116jfh5ravaixivqx4a4bz0lbb9c49d5r83nwmripja56zdbpgr0";
  };

  NIX_CFLAGS_COMPILE = "-I${libnotify}/include/libnotify";

  patchPhase = ''
    sed -i -e 's/ [^ ]*-gcc/ gcc/' -e 's/-march[^ ]*//' \
        -e 's/GLIB_CFLAGS =.*/GLIB_CFLAGS=`pkg-config --cflags glib-2.0 gdk-pixbuf-2.0 libnotify purple dbus-glib-1`/' Makefile
    pkg-config --cflags glib-2.0 gdk-pixbuf-2.0 libnotify
  '';

  buildPhase  = "make libskype.so libskype_dbus.so";

  installPhase = ''
    mkdir -p $out/pixmaps/pidgin/protocols/{16,22,48} $out/bin $out/lib/pidgin
    cp icons/16/skypeout.png $out/pixmaps/pidgin/protocols/16
    cp icons/22/skypeout.png $out/pixmaps/pidgin/protocols/22
    cp icons/48/skypeout.png $out/pixmaps/pidgin/protocols/48
    cp libskype.so libskype_dbus.so $out/lib/pidgin
  '';

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  buildInputs = [ pidgin pkgconfig libnotify gdk_pixbuf glib dbus dbus_glib ];

  meta = {
    homepage = https://github.com/novas0x2a/skype4pidgin;
    license = stdenv.lib.licenses.gpl3Plus;
    description = "Plugin to use a running skype account through pidgin";
  };
}
