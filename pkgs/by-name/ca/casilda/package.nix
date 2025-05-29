{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "casilda";
    tag = finalAttrs.version;
    hash = "sha256-wTYx4Wj8u52+yNc/A5Lg0zqmhKh8X0q99e+TilpUrC4=";
  };

  patches = [
    # Fix missing clock_gettime function
    # https://gitlab.gnome.org/jpu/casilda/-/merge_requests/4
    (fetchpatch {
      url = "https://gitlab.gnome.org/jpu/casilda/-/commit/dcebb8e67d6dc7c47332d1c76a1d5bf60eaee7b1.patch";
      hash = "sha256-l3zu29PPRwzDuoeoqUs4Gi3JziyZ9vDdqvRfz7GQ4Sw=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

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
  ];

  propagatedBuildInputs = [
    gtk4
    wlroots_0_18 # todo: move to buildInputs after https://gitlab.gnome.org/jpu/casilda/-/merge_requests/7
  ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/jpu/casilda";
    description = "Simple Wayland compositor widget for Gtk 4 which can be used to embed other processes windows in Gtk 4 application";
    maintainers = with lib.maintainers; [ emaryn ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
