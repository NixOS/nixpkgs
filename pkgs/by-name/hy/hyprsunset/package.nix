{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  hyprland-protocols,
  hyprutils,
  hyprwayland-scanner,
  wayland,
  wayland-protocols,
  wayland-scanner,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsunset";
  version = "0-unstable-2024-10-08";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsunset";
    rev = "f535c1894d71d7639d19b52f5b72e1ac840c2512";
    hash = "sha256-SVkcePzX9PAlWsPSGBaxiNFCouiQmGOezhMo0+zhDIQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprutils
    wayland
    wayland-protocols
    wayland-scanner
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprsunset";
    description = "Application to enable a blue-light filter on Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      fufexan
      johnrtitor
    ];
    mainProgram = "hyprsunset";
  };
})
