{ lib
, fetchFromGitHub
, wayland
}:
{
  version = "unstable-2023-04-06";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "803c00db1191604d50766358dbc5be2de4fcb4e7";
    hash = "sha256-+AagxTHrzKgngG+guIWAIV5hX1HkkvMbDxbUq2IVwAM=";
  };

  meta = with lib; {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
