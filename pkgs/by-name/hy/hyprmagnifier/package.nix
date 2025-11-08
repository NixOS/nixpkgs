{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprwayland-scanner,
  libxkbcommon,
  pango,
  libjpeg,
  hyprutils,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "hyprmagnifier";
  version = "0.0.1-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "st0rmbtw";
    repo = "hyprmagnifier";
    rev = "ce05ed35a1a7f9df976be7ee604d291ddad9c91c";
    hash = "sha256-vsQnL3R7lPKsUlDQKXirWMj/3qI377g7PkKlN+eVDTI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    hyprwayland-scanner
    libxkbcommon
    pango
    libjpeg
    hyprutils
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "wlroots-compatible Wayland magnifier that does not suck";
    homepage = "https://github.com/st0rmbtw/hyprmagnifier";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      matthewcroughan
    ];
    mainProgram = "hyprmagnifier";
    platforms = lib.platforms.all;
  };
}
