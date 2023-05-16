{ lib
, fetchFromGitHub
, wayland
}:
let
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-C5AO0KnyAFJaCkOn+5nJfWm0kyiPn/Awh0lKTjhgr7Y=";
=======
    hash = "sha256-zHDa8LCZs05TZHQSIZ3ucwyMPglBGHcqTBzfkLjYXTM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
