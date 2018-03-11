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
  name = "dino-unstable-2018-02-11";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "5436d716c0f508eb8ab70f322da862f996ce421e";
    sha256 = "0yxkhl9xm5f0j2i9vxgyabpa5fwja0329fmg0878mqsm89nzz3am";
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
