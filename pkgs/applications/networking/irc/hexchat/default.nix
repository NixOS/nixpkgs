{ stdenv, fetchurl, pkgconfig, gtk, perl, python, gettext
, libtool, pciutils, dbus_glib, libcanberra, libproxy
, libsexy, enchant, libnotify, openssl
, desktop_file_utils, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  version = "2.9.6.1";
  name = "hexchat-${version}";

  src = fetchurl {
    url = "http://dl.hexchat.net/hexchat/${name}.tar.xz";
    sha256 = "0w34jr1pqril6r011fwxv40m17bnb88q9cv5hf08mv0a9lygyrv2";
  };

  buildInputs = [
    pkgconfig gtk perl python gettext
    libtool pciutils dbus_glib libcanberra libproxy
    libsexy libnotify openssl
    desktop_file_utils hicolor_icon_theme
  ];

  configureFlags = [ "--enable-shm" "--enable-textfe" ];

  meta = {
    description = "A popular and easy to use graphical IRC (chat) client";
    homepage = http://hexchat.github.io/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
