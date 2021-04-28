{ lib, stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkg-config, gettext
, gobject-introspection, gnome3, glib, gdk-pixbuf, gtk3, glib-networking
, xorg, libXdmcp, libxkbcommon
, libnotify, libsoup, libgee
, librsvg, libsignal-protocol-c
, fetchpatch
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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "v${version}";
    sha256 = "0wy1hb3kz3k4gqqwx308n37cqag2d017jwfz0b5s30nkx2pbwspw";
  };

  patches = [
    # Fixes https://github.com/dino/dino/issues/1010 (double' is not a supported generic type argument)
    (fetchpatch {
      name = "dino-vala-boxing.patch";
      url = "https://github.com/dino/dino/commit/9acb54df9254609f2fe4de83c9047d408412de28.patch";
      sha256 = "1jz4r7d8b1ljwgq846wihp864b6gjdkgh6fnmxh13b2i10x52xsm";
    })
  ];

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
    gnome3.adwaita-icon-theme
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
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mic92 qyliss ];
  };
}
