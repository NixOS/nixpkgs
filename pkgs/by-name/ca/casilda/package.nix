{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gtk4,
  wayland-protocols,
  libepoxy,
  wayland,
  wayland-scanner,
  wlroots_0_18,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casilda";
  version = "0.3.0-unstable-2025-06-16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "casilda";
    rev = "5b5933d32f0221341c98a25dea1ce5ef78199a79";
    hash = "sha256-LrXoVK7KMjIko6jUkrKY06QdZMQaVrHhG7/C5ickdJA=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    libepoxy
    glib
    wayland-protocols
    wayland # for wayland-server
    libxkbcommon
    wlroots_0_18
  ];

  propagatedBuildInputs = [ gtk4 ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/jpu/casilda";
    description = "Simple Wayland compositor widget for Gtk 4 which can be used to embed other processes windows in Gtk 4 application";
    maintainers = with lib.maintainers; [ emaryn ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
