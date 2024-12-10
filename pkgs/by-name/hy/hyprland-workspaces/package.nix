{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-workspaces";
    rev = "v${version}";
    hash = "sha256-P+EJoZJqSlpMX1bWOkQYlKR577nTTe1luWKK5GS9Pn4=";
  };

  cargoHash = "sha256-vUlr12K/vYJE+HlSgulE2aSowU+pT9VPCaCp7Ix9ChM=";

  meta = with lib; {
    description = "Multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      kiike
      donovanglover
    ];
    mainProgram = "hyprland-workspaces";
  };
}
