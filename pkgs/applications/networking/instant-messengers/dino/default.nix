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
  name = "dino-unstable-2017-06-21";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "3f0089db86e2057293a33453361678989919147f";
    sha256 = "011wd6qi8nagig8418hibgnsmznd76dvp3p2dzzr4wyrb7d6cgcb";
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
