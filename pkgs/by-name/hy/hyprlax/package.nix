{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlax";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "sandwichfarm";
    repo = "hyprlax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RIeMsQt6MxSTI7TunIxk7wd08sYmr3EvjAQifr+M4e8=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libGL
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Dynamic parallax wallpaper engine with multi-compositor support for Linux";
    longDescription = ''
      hyprlax is a GPU-accelerated Wayland wallpaper daemon with parallax effects.

      Features:
      - Buttery smooth GPU-accelerated animations with configurable FPS
      - Multi-layer parallax with depth-of-field blur effects
      - Multi-compositor support (Hyprland, Sway, River, Niri, generic Wayland)
      - Customizable per-layer easing functions, delays, and animation parameters
      - Dynamic layer management via IPC (add, remove, modify layers at runtime)
      - Lightweight native client using compositor-specific protocols
      - Seamless animation interrupts and chaining
    '';
    homepage = "https://github.com/sandwichfarm/hyprlax";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers._6543 ];
    mainProgram = "hyprlax";
  };
})
