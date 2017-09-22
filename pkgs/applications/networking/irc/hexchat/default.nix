{ stdenv, fetchFromGitHub, pkgconfig, gtk2, lua, perl, python2
, libtool, pciutils, dbus_glib, libcanberra_gtk2, libproxy
, libsexy, enchant, libnotify, openssl, intltool
, desktop_file_utils, hicolor_icon_theme
, autoconf, automake, autoconf-archive
}:

stdenv.mkDerivation rec {
  version = "2.12.4";
  name = "hexchat-${version}";

  src = fetchFromGitHub {
    owner = "hexchat";
    repo = "hexchat";
    rev = "v${version}";
    sha256 = "1z8v7jg1mc2277k3jihnq4rixw1q27305aw6b6rpb1x7vpiy2zr3";
  };

  nativeBuildInputs = [
    pkgconfig libtool intltool
    autoconf autoconf-archive automake
  ];

  buildInputs = [
    gtk2 lua perl python2 pciutils dbus_glib libcanberra_gtk2 libproxy
    libsexy libnotify openssl desktop_file_utils hicolor_icon_theme
  ];

  enableParallelBuilding = true;

  #hexchat and heachat-text loads enchant spell checking library at run time and so it needs to have route to the path
  patchPhase = ''
    sed -i "s,libenchant.so.1,${enchant}/lib/libenchant.so.1,g" src/fe-gtk/sexy-spell-entry.c
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-shm" "--enable-textfe" ];

  meta = with stdenv.lib; {
    description = "A popular and easy to use graphical IRC (chat) client";
    homepage = https://hexchat.github.io/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
