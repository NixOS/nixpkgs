{ stdenv, fetchFromGitHub
, vala, cmake, wrapGAppsHook, pkgconfig, gettext
, gobjectIntrospection, gnome3, glib, gdk_pixbuf, gtk3, glib_networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup
, libgcrypt
, epoxy
, at_spi2_core
, sqlite
, dbus
, gpgme
, pcre
 }:

stdenv.mkDerivation rec {
  name = "dino-unstable-2017-09-26";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "9d8e1e88ec61403659a8cc410d5c4414e3bd3a96";
    sha256 = "1p8sda99n8zsb49qd6wzwb8hddlgrzr2hp7il5v7yqxjjm2vgqfl";
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
    gnome3.defaultIconTheme
    sqlite
    gdk_pixbuf
    gtk3
    libnotify
    gpgme
    libgcrypt
    libsoup
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
