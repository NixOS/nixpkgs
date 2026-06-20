{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "hypr-relay";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Vega-0b1";
    repo = "hypr-relay";
    rev = "v0.2.1";
    hash = "sha256-EoZMMTj6ob+Jeeg4DpZirVi2yWMLPVwcmPK1xIHQf/Y=";
  };

  cargoHash = "sha256-Bl2J2ti0+CpSq9tNlB+3eJd+mwN6JJF7aNnuW/nJde0=";

  meta = {
    description = "Lightweight daemon for Hyprland that bridges system events to desktop notifications";
    homepage = "https://github.com/Vega-0b1/hypr-relay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jcvega ];
    mainProgram = "hypr-relay";
    platforms = lib.platforms.linux;
  };
}
