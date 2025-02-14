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

  useFetchCargoVendor = true;

  cargoHash = "sha256-aT8LfBVOEVUvzgPlBIOXTgT+WXEt3vHMDyCcl9jT5/E=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [ hyprland-workspaces ];

  postInstall = ''
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
