{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4QGLTimIpx74gWUyHCheUZZT1WgVzBoJRY8OlUDdOh4=";
  };

  cargoHash = "sha256-9ndP0nyRBCdOGth4UWA263IvjbgnVW2x9PK8oTaMrxg=";

  meta = with lib; {
    description = "A multi-monitor-aware Hyprland workspace widget helper.";
    homepage = "https://github.com/FieldOfClay/hyprland-workspaces";
    license = licenses.mit;
    maintainers = with maintainers; [ kiike ];
  };
}
