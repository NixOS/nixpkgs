{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.16";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-per-window-layout";
    rev = version;
    hash = "sha256-+1gmLNWuV5DhXjC6aRD1rHIOpX+OCX1Ak45pi+ixIFw=";
  };

  cargoHash = "sha256-k8YNGqKw5MPHdXye8loqGkexY75jjkJSnzaWmye945I=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
