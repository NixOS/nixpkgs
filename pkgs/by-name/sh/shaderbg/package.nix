{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  pkg-config,
  wayland-scanner,
  wayland,
  libGL,
}:
stdenv.mkDerivation {
  pname = "shaderbg";
  version = "0-unstable-2024-11-26";
  src = fetchFromGitHub {
    owner = "Mr-Pine";
    repo = "shaderbg";
    rev = "cf9b135069550f8d7c8411d8a53285882034331c";
    hash = "sha256-J+fRzSTEMlT9oLVZqbstrDxuKiJTAHNTLxB8IPgdom0=";
  };
  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wayland
    libGL
  ];
  meta = {
    description = "Shader-based live wallpaper program for compositors that support wlr-layer-shell (Sway and others)";
    homepage = "https://github.com/Mr-Pine/shaderbg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bokicoder ];
    mainProgram = "shaderbg";
    platforms = lib.platforms.linux;
  };
}
