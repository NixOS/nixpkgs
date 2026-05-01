{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprwayland-scanner,
  wayland-scanner,
  aquamarine,
  cairo,
  gtest,
  hyprgraphics,
  hyprlang,
  hyprutils,
  iniparser,
  libdrm,
  libgbm,
  libGL,
  libxkbcommon,
  pango,
  pixman,
  wayland,
  wayland-protocols,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprtoolkit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprtoolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M+mlYKvzqW+TSoJ4MH9U+HcFoUmWc1etiXehyLEVB2M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
    wayland-scanner
  ];

  buildInputs = [
    aquamarine
    cairo
    gtest
    hyprgraphics
    hyprlang
    hyprutils
    iniparser
    libdrm
    libgbm
    libGL
    libxkbcommon
    pango
    pixman
    wayland
    wayland-protocols
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A modern C++ Wayland-native GUI toolkit";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
  };
})
