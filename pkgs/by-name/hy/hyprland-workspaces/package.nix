{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-workspaces";
    rev = "v${version}";
    hash = "sha256-GhUjvFMlgjTdgtV9ASW7IqE2dBktPyOlRwg6qM1r7vc=";
  };

  cargoHash = "sha256-RZVQSkegX8Fa9SNY7tGNxyu312oeDjXK4U1+1/UIAyA=";

  meta = with lib; {
    description = "Multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-workspaces";
  };
}
