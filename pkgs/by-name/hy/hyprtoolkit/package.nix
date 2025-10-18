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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprtoolkit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AQCTRH8VsrHzOHL0ueXt/6OQtSSfZbT3XUBI4sq8rx4=";
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

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A modern C++ Wayland-native GUI toolkit";
    license = licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (wayland.meta) platforms;
    broken = gcc15Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprtoolkit";
  };
})
