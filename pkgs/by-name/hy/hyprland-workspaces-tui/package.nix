{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  hyprland-workspaces,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces-tui";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "hyprland-workspaces-tui";
    tag = version;
    hash = "sha256-QMwiBQGAybdL8FaUil6tFzSFg4nN/9mGVoqiDFwGZec=";
  };

  cargoHash = "sha256-CPlNCq6vowyeMlByeHmDr/6LwhB3jZYShraQ2cvtjgE=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    hyprland-workspaces
  ];

  postFixup = ''
    wrapProgram $out/bin/hyprland-workspaces-tui \
      --set PATH ${hyprland-workspaces}/bin:$PATH

    installShellCompletion --cmd hyprland-workspaces-tui \
      --bash <($out/bin/hyprland-workspaces-tui --completions bash) \
      --zsh <($out/bin/hyprland-workspaces-tui --completions zsh) \
      --fish <($out/bin/hyprland-workspaces-tui --completions fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based user interface (TUI) wrapper for the hyprland-workspaces CLI utility";
    homepage = "https://github.com/Levizor/hyprland-workspaces-tui";
    license = lib.licenses.mit;
    mainProgram = "hyprland-workspaces-tui";
    maintainers = with lib.maintainers; [ Levizor ];
  };
}
