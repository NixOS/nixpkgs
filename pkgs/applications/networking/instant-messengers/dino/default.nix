{ stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkgconfig, gettext
, gobject-introspection, gnome3, glib, gdk-pixbuf, gtk3, glib-networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup, libgee, utillinux, libselinux, libsepol, libpsl, brotli
, librsvg, libsignal-protocol-c
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
  pname = "dino";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "v${version}";
    sha256 = "1k5cgj5n8s40i71wqdh6m1q0njl45ichfdbbywx9rga5hljz1c54";
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
    xorg.libXtst
    libXdmcp
    libxkbcommon
    epoxy
    at-spi2-core
    dbus
    icu
    utillinux
    libselinux
    libsepol
    libpsl
    brotli
    libsignal-protocol-c
    librsvg
  ];

  meta = with stdenv.lib; {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    homepage = https://github.com/dino/dino;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 qyliss ];
  };
}
