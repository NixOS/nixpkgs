{ stdenv, fetchFromGitHub
, vala, cmake, wrapGAppsHook, pkgconfig, gettext
, gobjectIntrospection, gnome3, glib, gdk_pixbuf, gtk3, glib_networking
, xorg, libXdmcp, libxkbcommon
, libnotify
, libgcrypt
, epoxy
, at_spi2_core
, sqlite
, dbus
, gpgme
, pcre
 }:

stdenv.mkDerivation rec {
  name = "dino-unstable-2017-04-24";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "3eb9aa0fa79ea9fcebb5f702f81c2e54aafdc8cc";
    sha256 = "0z9ql419q53f20bw4pfwsafxl4qqnz0ip91qibsf9jn5d56kcdwv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    vala
    cmake
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    gobjectIntrospection
    glib_networking
    glib
    gnome3.libgee
    sqlite
    gdk_pixbuf
    gtk3
    libnotify
    gpgme
    libgcrypt
    pcre
    xorg.libxcb
    xorg.libpthreadstubs
    libXdmcp
    libxkbcommon
    epoxy
    at_spi2_core
    dbus
    gettext
  ];

  meta = with stdenv.lib; {
    description = "Modern Jabber/XMPP Client using GTK+/Vala";
    homepage = https://github.com/dino/dino;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
