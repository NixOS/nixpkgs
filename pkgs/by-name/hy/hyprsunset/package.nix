{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  hyprland-protocols,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  wayland,
  wayland-protocols,
  wayland-scanner,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsunset";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsunset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ctk7zophp8obM/u9S2c8a6nOWV+VeIzq6ma+dI5BE3s=";
  };

  postPatch = ''
    # hyprwayland-scanner is not required at runtime
    substituteInPlace CMakeLists.txt --replace-fail "hyprwayland-scanner>=0.4.0" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    hyprutils
    wayland
    wayland-protocols
    wayland-scanner
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprsunset";
    description = "Application to enable a blue-light filter on Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprsunset";
  };
})
