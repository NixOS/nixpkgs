{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-per-window-layout";
    rev = version;
    hash = "sha256-dYoHa4b7BZc/LGVLsNs/LTj4sSMaFel+QE0TUv5kGAk=";
  };

  cargoHash = "sha256-wXPc3jAY8E0k8cn4Z2OIhCyrfszzlzFmhQZIZay16Ec=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
