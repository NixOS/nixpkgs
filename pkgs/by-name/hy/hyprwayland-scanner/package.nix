{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pugixml,
  nix-update-script,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwayland-scanner";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwayland-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jxixw6wZphUp+nHYxOKUYSckL17QMBx2d5Zp0rJHr1g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pugixml
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprwayland-scanner";
    description = "Hyprland version of wayland-scanner in and for C++";
    changelog = "https://github.com/hyprwm/hyprwayland-scanner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprwayland-scanner";
    platforms = lib.platforms.linux;
  };
})
