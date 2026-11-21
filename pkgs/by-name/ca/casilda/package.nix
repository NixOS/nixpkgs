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
  wayland,
  wayland-scanner,
  wlroots_0_20,
  libxkbcommon,
  libdrm,
  pixman,
  linuxHeaders,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casilda";
  version = "1.6.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "casilda";
    tag = finalAttrs.version;
    hash = "sha256-1Iq0RKte56gg69MRlEhfu5aWc+Vl7HgopS7RGIrf59w=";
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
    glib
    wayland-protocols
    wayland # for wayland-server
    libxkbcommon
    libdrm
    pixman
    wlroots_0_20
  ];

  env.NIX_CFLAGS_COMPILE = "-I${linuxHeaders}/include/drm";

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
