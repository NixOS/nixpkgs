{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  hyprland-workspaces,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces-tui";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "hyprland-workspaces-tui";
    tag = version;
    hash = "sha256-3QmqoyWmtC4ps8dtIWEoLjzdzKAXOujyz+GgOlo172Q=";
  };

  cargoHash = "sha256-0bADed6AUMx5UkJ3oqxthaKt94ocEn7xXsgaH0wOiNM=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    hyprland-workspaces
  ];

  postFixup = ''
    wrapProgram $out/bin/hyprland-workspaces-tui \
      --set PATH ${hyprland-workspaces}/bin:$PATH
  '';

  meta = {
    description = "Terminal-based user interface (TUI) wrapper for the hyprland-workspaces CLI utility";
    homepage = "https://github.com/Levizor/hyprland-workspaces-tui";
    license = lib.licenses.mit;
    mainProgram = "hyprland-workspaces-tui";
    maintainers = with lib.maintainers; [ Levizor ];
  };
}
