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
  sdbus-cpp_2,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-20a3pg94dyLFflbBIN+EYJ04nWfWldTfd2YmB/rcrqY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    hyprlang
    hyprutils
    sdbus-cpp_2
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
