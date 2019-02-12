{ stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkgconfig, gettext
, gobject-introspection, gnome3, glib, gdk_pixbuf, gtk3, glib-networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup
, libgcrypt
, epoxy
, at-spi2-core
, sqlite
, dbus
, gpgme
, pcre
, qrencode
, icu
 }:

stdenv.mkDerivation rec {
  name = "dino-unstable-2019-02-06";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "864196d2acef3db047160b9da5803805067276c3";
    sha256 = "10nyq9marclzbkxisackp402gimgs7gb0llgjm922c593c5h39cq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    vala
    cmake
    ninja
    pkgconfig
    wrapGAppsHook
    gettext
  ];

  buildInputs = [
    qrencode
    gobject-introspection
    glib-networking
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
    at-spi2-core
    dbus
    icu
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Modern Jabber/XMPP Client using GTK+/Vala";
    homepage = https://github.com/dino/dino;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
