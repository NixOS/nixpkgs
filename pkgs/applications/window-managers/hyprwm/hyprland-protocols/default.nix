{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-HUklK5u86w2Yh9dOkk4FdsL8eehcOZ95jPhLixGDRQY=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
})
