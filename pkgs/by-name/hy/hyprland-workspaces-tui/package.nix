{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  hyprland-workspaces,
  nix-update-script,
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

  useFetchCargoVendor = true;

  cargoHash = "sha256-VjYLqRXJhR8MZD+qcwqgw36Xh0RafJeAnuHzO+pab4s=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ hyprland-workspaces ];

  postFixup = ''
    wrapProgram $out/bin/hyprland-workspaces-tui \
      --suffix PATH : ${lib.makeBinPath [ hyprland-workspaces ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based user interface (TUI) wrapper for the hyprland-workspaces CLI utility";
    homepage = "https://github.com/Levizor/hyprland-workspaces-tui";
    license = lib.licenses.mit;
    mainProgram = "hyprland-workspaces-tui";
    maintainers = with lib.maintainers; [ Levizor ];
    platforms = lib.platforms.linux;
  };
}
