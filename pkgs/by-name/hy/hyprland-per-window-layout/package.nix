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
    repo = "hyprland-per-window-layout";
    rev = version;
    hash = "sha256-Bwdh+Cy5LTRSBDfk4r28FmPRUEHYI++nKRhS9eSSbyg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QXT7utSEF5S5MWAng4fKMoloUJovxLT8oLUK9dJEb/0=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
