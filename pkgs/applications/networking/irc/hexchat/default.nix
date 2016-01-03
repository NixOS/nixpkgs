{ stdenv, fetchurl, pkgconfig, gtk, perl, python, gettext
, libtool, pciutils, dbus_glib, libcanberra, libproxy
, libsexy, enchant, libnotify, openssl, intltool
, desktop_file_utils, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  version = "2.10.2";
  name = "hexchat-${version}";

  src = fetchurl {
    url = "http://dl.hexchat.net/hexchat/${name}.tar.xz";
    sha256 = "0b5mw6jxa7c93nbgiwijm7j7klm6nccx6l9zyainyrbnqmjz7sw7";
  };

  buildInputs = [
    pkgconfig gtk perl python gettext
    libtool pciutils dbus_glib libcanberra libproxy
    libsexy libnotify openssl intltool
    desktop_file_utils hicolor_icon_theme
  ];

 #hexchat and heachat-text loads enchant spell checking library at run time and so it needs to have route to the path
  patchPhase = ''
    sed -i "s,libenchant.so.1,${enchant}/lib/libenchant.so.1,g" src/fe-gtk/sexy-spell-entry.c
  '';

  configureFlags = [ "--enable-shm" "--enable-textfe" ];

  meta = with stdenv.lib; {
    description = "A popular and easy to use graphical IRC (chat) client";
    homepage = http://hexchat.github.io/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
