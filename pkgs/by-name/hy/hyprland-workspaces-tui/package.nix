{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  hyprland-workspaces,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces-tui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "hyprland-workspaces-tui";
    tag = version;
    hash = "sha256-DLu7njrD5i9FeNWVZGBTKki70FurIGxtwgS6HbA7YLE=";
  };

  cargoHash = "sha256-1NZrpqbFiYSJtFNnlDwXX4J4rLwa9XlwUT+boMtr4tk=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [ hyprland-workspaces ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hyprland-workspaces-tui \
      --bash <($out/bin/hyprland-workspaces-tui --completions bash) \
      --zsh <($out/bin/hyprland-workspaces-tui --completions zsh) \
      --fish <($out/bin/hyprland-workspaces-tui --completions fish)
  '';

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
