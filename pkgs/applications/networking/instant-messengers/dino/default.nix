{ lib, stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkg-config, gettext
, gobject-introspection, gnome, glib, gdk-pixbuf, gtk3, glib-networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup, libgee
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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "v${version}";
    sha256 = "sha256-uYP3D2uyvfRP91fq/1jKOaKgp/+How0SUwmxSrLLH4c=";
  };

  nativeBuildInputs = [
    vala
    cmake
    ninja
    pkg-config
    wrapGAppsHook
    gettext
  ];

  buildInputs = [
    qrencode
    gobject-introspection
    glib-networking
    glib
    libgee
    gnome.adwaita-icon-theme
    sqlite
    gdk-pixbuf
    gtk3
    libnotify
    gpgme
    libgcrypt
    libsoup
    pcre
    epoxy
    at-spi2-core
    dbus
    icu
    libsignal-protocol-c
    librsvg
  ] ++ lib.optionals (!stdenv.isDarwin) [
    xorg.libxcb
    xorg.libpthreadstubs
    libXdmcp
    libxkbcommon
  ];

  # Dino looks for plugins with a .so filename extension, even on macOS where
  # .dylib is appropriate, and despite the fact that it builds said plugins with
  # that as their filename extension
  #
  # Therefore, on macOS rename all of the plugins to use correct names that Dino
  # will load
  #
  # See https://github.com/dino/dino/wiki/macOS
  postFixup = lib.optionalString (stdenv.isDarwin) ''
    cd "$out/lib/dino/plugins/"
    for f in *.dylib; do
      mv "$f" "$(basename "$f" .dylib).so"
    done
  '';

  meta = with lib; {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    homepage = "https://github.com/dino/dino";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ qyliss ];
  };
}
