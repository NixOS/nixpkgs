{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprwayland-scanner,
  abseil-cpp,
  aquamarine,
  gtest,
  hyprgraphics,
  hyprlang,
  hyprutils,
  iniparser,
  libgbm,
  libxkbcommon,
  wayland-scanner,
  wayland-protocols,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprtoolkit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprtoolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rb1yZZ0PR4lRrXC2BdiMjGFttZe6MFQFSnx3wD4dko=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
    wayland-scanner
  ];

  propagatedBuildInputs = [
    aquamarine
    hyprgraphics
    hyprutils
  ];

  buildInputs = [
    abseil-cpp
    gtest
    hyprlang
    iniparser
    libgbm
    libxkbcommon
    wayland-protocols
    wayland-scanner
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A modern C++ Wayland-native GUI toolkit";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
  };
})
