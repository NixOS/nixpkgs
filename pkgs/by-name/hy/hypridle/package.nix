{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  hyprutils,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprlang,
  sdbus-cpp,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4EgQyprji92cmhGaQQsw6eN6cmEkQKs0+MeD7YLgHlg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    hyprlang
    hyprutils
    sdbus-cpp
    systemd
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "hypridle";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
