{ lib
, fetchFromGitHub
, wayland
}:
let
  version = "0.3.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${version}";
    hash = "sha256-zHDa8LCZs05TZHQSIZ3ucwyMPglBGHcqTBzfkLjYXTM=";
  };

  meta = with lib; {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
