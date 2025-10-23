{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-protocols";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+KEVnKBe8wz+a6dTLq8YDcF3UrhQElwsYJaVaHXJtoI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})
