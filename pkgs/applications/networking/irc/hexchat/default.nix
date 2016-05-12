{ stdenv, fetchurl, pkgconfig, gtk, lua, perl, python
, libtool, pciutils, dbus_glib, libcanberra, libproxy
, libsexy, enchant, libnotify, openssl, intltool
, desktop_file_utils, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  version = "2.12.1";
  name = "hexchat-${version}";

  src = fetchurl {
    url = "http://dl.hexchat.net/hexchat/${name}.tar.xz";
    sha256 = "0svwz9ldrry1sn35jywgpacjj1cf3xl3k74ynwn8rjvxs73b00aj";
  };

  nativeBuildInputs = [
    pkgconfig libtool intltool
  ];

  buildInputs = [
    gtk lua perl python pciutils dbus_glib libcanberra libproxy
    libsexy libnotify openssl desktop_file_utils hicolor_icon_theme
  ];

  enableParallelBuilding = true;

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
