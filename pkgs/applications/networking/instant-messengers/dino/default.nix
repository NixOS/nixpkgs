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
 }:

stdenv.mkDerivation rec {
  name = "dino-unstable-2018-09-21";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "6b7ef800f54e781a618425236ba8d4ed2f2fef9c";
    sha256 = "1si815b6y06lridj88hws0dgq54w9jfam9sqbrq3cfcvmhc38ysk";
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
