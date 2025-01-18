{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-protocols";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9OV4lOqrEJVLdOrpNN/9msNwAhI6FQTu4N7fufilG08=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
})
