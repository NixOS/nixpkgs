{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-protocols";
    rev = "v${finalAttrs.version}";
    hash = "sha256-laKgI3mr2qz6tas/q3tuGPxMdsGhBi/w+HO+hO2f1AY=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.hyprland.members;
    platforms = lib.platforms.linux;
  };
})
