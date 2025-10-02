{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  desktop-file-utils,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  adwaita-icon-theme,
  hicolor-icon-theme,
  libepoxy,
  gst_all_1,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  graphene,
  sqlite,
  openssl,
  curl,
  glib-networking,
  libsecret,
  dbus,
  gettext,
  librsvg,
  mold,
}:

rustPlatform.buildRustPackage rec {
  pname = "reel";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "arsfeld";
    repo = "reel";
    tag = "v${version}";
    hash = "sha256-WjOIBEkLHFL25RpCfe3ksRhyok6QkMl/XBgsNHdAk/I=";
  };

  cargoHash = "sha256-DtG/CyZA3BMIJConaracNqYz9zB8f1v25+3liXnJJbM=";

  nativeBuildInputs = [
    desktop-file-utils
    mold
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    adwaita-icon-theme
    cairo
    curl
    dbus
    dbus.dev
    gdk-pixbuf
    gettext
    glib
    glib-networking
    graphene
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    hicolor-icon-theme
    libadwaita
    libepoxy
    librsvg
    libsecret
    openssl
    pango
    sqlite
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
    gtk-update-icon-cache -q -t -f $out/share/icons/hicolor
  '';

  meta = {
    description = "Reel - A modern, native media player for the GNOME desktop";
    homepage = "https://github.com/arsfeld/reel";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    platforms = lib.platforms.linux;
  };
}
