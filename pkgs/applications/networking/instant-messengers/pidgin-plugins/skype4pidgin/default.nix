{ stdenv, fetchsvn, pkgconfig, pidgin, libnotify, gdk_pixbuf, glib, dbus
, dbus_glib }:

let
  rev = 657;
in
stdenv.mkDerivation rec {
  name = "skype4pidgin-svn-657";
  src = fetchsvn {
    url = "http://skype4pidgin.googlecode.com/svn/trunk";
    inherit rev;
    sha256 = "0sg91rqkg6mjdkwxjbs7bmh65sm5sj6fzygkfiz8av3zjzmj127b";
  };

  NIX_CFLAGS_COMPILE = "-I${libnotify}/include/libnotify";

  patchPhase = ''
    sed -i -e 's/ [^ ]*-gcc/ gcc/' -e 's/-march[^ ]*//' \
        -e 's/glib-2.0/glib-2.0 gdk-pixbuf-2.0 libnotify purple dbus-glib-1/' Makefile
    pkg-config --cflags glib-2.0 gdk-pixbuf-2.0 libnotify
  '';

  buildPhase  = "make libskype.so libskype_dbus.so";

  installPhase = ''
    ensureDir $out/pixmaps/pidgin/protocols/{16,22,48} $out/bin $out/lib/pidgin
    cp icons/16/skypeout.png $out/pixmaps/pidgin/protocols/16
    cp icons/22/skypeout.png $out/pixmaps/pidgin/protocols/22
    cp icons/48/skypeout.png $out/pixmaps/pidgin/protocols/48
    cp libskype.so libskype_dbus.so $out/lib/pidgin
  '';

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  buildInputs = [ pidgin pkgconfig libnotify gdk_pixbuf glib dbus dbus_glib ];
}
