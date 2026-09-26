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
  wlroots_0_20,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casilda";
  version = "1.2.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "casilda";
    tag = finalAttrs.version;
    hash = "sha256-JMDS+fx0vUZnfNz5bzmTy8/4BkgMypWBp+qjorTVmK4=";
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
    wlroots_0_20
  ];

  propagatedBuildInputs = [ gtk4 ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/jpu/casilda";
    description = "Simple Wayland compositor widget for Gtk 4 which can be used to embed other processes windows in Gtk 4 application";
    maintainers = with lib.maintainers; [ clerie ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
