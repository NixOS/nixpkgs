{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gtk3,
  gtk4,
  libepoxy,
  wayland-scanner,
  wlroots_0_18,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casilda";
  version = "0.2.0-unstable-2025-03-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "casilda";
    rev = "9b3a497e693c85ace09f630f15cb1f9eff015c83";
    hash = "sha256-2X4syV9p2LdavkC4QZd2W5O57h3uWHobsx5E5cRr/xU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    libepoxy
    gtk4
    glib
    gtk3
    wayland-scanner
    wlroots_0_18
    libxkbcommon
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/jpu/casilda";
    description = "Simple Wayland compositor widget for Gtk 4 which can be used to embed other processes windows in Gtk 4 application";
    maintainers = with lib.maintainers; [ emaryn ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
