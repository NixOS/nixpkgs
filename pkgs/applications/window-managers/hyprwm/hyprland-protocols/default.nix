{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-QPzwwlGKX95tl6ZEshboZbEwwAXww6lNLdVYd6T9Mrc=";
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
