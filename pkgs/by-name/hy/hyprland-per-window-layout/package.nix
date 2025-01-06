{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-Bwdh+Cy5LTRSBDfk4r28FmPRUEHYI++nKRhS9eSSbyg=";
  };

  cargoHash = "sha256-GX8Xo/1TwP/y+T1ErIjk+SriXyLpb1JDddYwod8DoxM=";

  meta = {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azazak123 ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
