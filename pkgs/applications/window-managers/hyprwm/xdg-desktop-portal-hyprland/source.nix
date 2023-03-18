{ lib
, fetchFromGitHub
, wayland
}:
{
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "85f49f4d6c9c398428117e9bdb588f53f09e52e0";
    hash = "sha256-qed+BV0NBt1egGCBEM7d5MiZJevQb8jd1WybfFM53Ak=";
  };

  meta = with lib; {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
