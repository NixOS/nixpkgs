{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-workspaces";
    rev = "v${version}";
    hash = "sha256-4QGLTimIpx74gWUyHCheUZZT1WgVzBoJRY8OlUDdOh4=";
  };

  cargoHash = "sha256-9ndP0nyRBCdOGth4UWA263IvjbgnVW2x9PK8oTaMrxg=";

  meta = with lib; {
    description = "A multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-workspaces";
  };
}
