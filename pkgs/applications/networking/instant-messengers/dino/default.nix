{ stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkgconfig, gettext
, gobject-introspection, gnome3, glib, gdk-pixbuf, gtk3, glib-networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup, libgee
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
  name = "dino-unstable-2019-08-27";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "ff6caf241c4d57d3ef124a8b7c3144a09f320ea0";
    sha256 = "1gjxfnywlypi3slvxb91b2mycrsqjinmafnkkngahyikr7gmqgnf";
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
    libgee
    gnome3.adwaita-icon-theme
    sqlite
    gdk-pixbuf
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
