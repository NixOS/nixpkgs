{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  wayland-scanner,
  cairo,
  libGL,
  libjpeg,
  libxkbcommon,
  pango,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "hyprmag";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "SIMULATAN";
    repo = "hyprmag";
    tag = finalAttrs.version;
    hash = "sha256-IHYxQeCcPH2XoRyTgFEi+HVlWGVAnaTdS0Jf96H9PNU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    libGL
    libjpeg
    libxkbcommon
    pango
    wayland
    wayland-protocols
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "wlroots-compatible Wayland screen magnifier, based on hyprpicker";
    homepage = "https://github.com/SIMULATAN/hyprmag";
    changelog = "https://github.com/SIMULATAN/hyprmag/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samiser ];
    mainProgram = "hyprmag";
    platforms = lib.platforms.linux;
  };
})
