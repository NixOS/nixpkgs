{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  dbus,
  pango,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdecor";
  version = "0.2.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libdecor";
    repo = "libdecor";
    rev = finalAttrs.version;
    hash = "sha256-sUktv/k+4IdJ55uH3F6z8XqaAOTic6miuyZ9U+NhtQQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "demo" false)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    dbus
    pango
    gtk3
  ];

  meta = {
    homepage = "https://gitlab.freedesktop.org/libdecor/libdecor";
    description = "Client-side decorations library for Wayland clients";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
  };
})
