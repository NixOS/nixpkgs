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
  name = "dino-unstable-2017-05-11";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "b09a056a13de131a4f2f072ffa2f795a0bb2abe7";
    sha256 = "1dis1kgaqb1925anmxlcy9n722zzyn5wvq8lmczi6h2h3j7wnnmz";
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
