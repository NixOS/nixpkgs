{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprlang,
  hyprutils,
  hyprland-protocols,
  hyprwayland-scanner,
  sdbus-cpp_2,
  systemdLibs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YzRWE3rCnsY0WDRJcn4KvyWUoe+5zdkUYNIaHGP9BZ4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
    wayland-scanner
    hyprland-protocols
    wayland-protocols
  ];

  buildInputs = [
    hyprlang
    hyprutils
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hypridle";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
