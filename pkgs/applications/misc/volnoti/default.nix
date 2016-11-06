{ stdenv, fetchFromGitHub
, pkgconfig, dbus, gdk_pixbuf, glib, libX11, gtk2, librsvg
, dbus_glib, autoreconfHook, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "volnoti-unstable-${version}";
  version = "2013-09-23";

  src = fetchFromGitHub {
    owner = "davidbrazdil";
    repo = "volnoti";
    rev = "4af7c8e54ecc499097121909f02ecb42a8a60d24";
    sha256 = "155lb7w563dkdkdn4752hl0zjhgnq3j4cvs9z98nb25k1xpmpki7";
  };

  patches = [ ./dbus-headers-fix.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook wrapGAppsHook ];

  buildInputs = [
    dbus gdk_pixbuf glib libX11 gtk2 dbus_glib librsvg
  ];

  meta = with stdenv.lib; {
    description = "Lightweight volume notification for Linux";
    homepage = "https://github.com/davidbrazdil/volnoti";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.gilligan ];
  };
}
