{ lib
, fetchFromGitHub
, wayland
}:
let
  version = "0.4.0";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${version}";
    hash = "sha256-r+XMyOoRXq+hlfjayb+fyi9kq2JK48TrwuNIAXqlj7U=";
  };

  meta = with lib; {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
