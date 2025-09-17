{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-per-window-layout";
    rev = version;
    hash = "sha256-wn1xFLi7CYb9A8fR0MaGYrOeIYuF8PCxbGcyQx33H6Y=";
  };

  cargoHash = "sha256-67ewLuhAVaZbUuAwWDZE51dS4T3EkWfYxS40IbvupiM=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}
