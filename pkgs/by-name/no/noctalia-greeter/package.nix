{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,
  wayland-scanner,

  cairo,
  fontconfig,
  freetype,
  glib,
  gtk4,
  libGL,
  librsvg,
  libwebp,
  libxkbcommon,
  pango,
  wayland,
  wayland-protocols,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noctalia-greeter";
  version = "0-unstable-2026-06-08";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-greeter";
    rev = "367ab83dcd9190010f093cfe0e123ba132a75b5a";
    hash = "sha256-/jQ/lkgjaH5EOTZRXk4YZaFrjrKhq/fzZsU6nm7wPt0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    glib
    gtk4
    libGL
    librsvg
    libwebp
    libxkbcommon
    pango
    wayland
    wayland-protocols
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`greetd` greeter for Noctalia";
    homepage = "https://github.com/noctalia-dev/noctalia-greeter";
    changelog = "https://github.com/noctalia-dev/noctalia-greeter/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dtomvan
      spacedentist
    ];
    mainProgram = "noctalia-greeter-session";
    platforms = lib.platforms.linux;
  };
})
