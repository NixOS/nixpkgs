{ stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkgconfig, gettext
, gobjectIntrospection, gnome3, glib, gdk_pixbuf, gtk3, glib-networking
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
 }:

stdenv.mkDerivation rec {
  name = "dino-unstable-2018-11-27";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "141db9e40a3a81cfa3ad3587dc47f69c541d0fde";
    sha256 = "006r1x7drlz39jjxlfdnxgrnambw9amhl9jcgf6p1dx71h1x8221";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    vala
    cmake
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    qrencode
    gobjectIntrospection
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
