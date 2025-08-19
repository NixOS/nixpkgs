{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-per-window-layout";
    rev = version;
    hash = "sha256-SOT2nrk2JKTzKE1QNhjAY9zjyG5z5nYFz7RJRrS3Tsk=";
  };

  cargoHash = "sha256-VzxO5xn864gnMR62iszTNwz1tU7A59dhQspsla90aRs=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
