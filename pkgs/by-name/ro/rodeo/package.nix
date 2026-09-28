{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rodeo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lordgreg";
    repo = "rodeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+elJAVUt7baiFyDSEczE4NngTs8tv9VxU9QxX0PZvxM=";
  };

  cargoHash = "sha256-YnSlEn6CUQU/rGFeki7SEknFpw4pRDP1AU+wNn6ac24=";

  nativeBuildInputs = [ installShellFiles ];

  # Same two sandbox-only failures skipped in flake.nix — see the comment
  # there for why (Nix sets $HOME to a nonexistent path during checkPhase,
  # and the macOS updater test assumes a context this sandbox doesn't have).
  checkFlags = [
    "--skip=config::tests::a_start_directory_that_no_longer_exists_falls_back_to_home"
    "--skip=updater::tests::macos_new_version_available"
  ];

  postInstall = ''
    installManPage docs/rodeo.1
    install -d "$out/share/rodeo/themes"
    install -m644 themes/*.toml "$out/share/rodeo/themes/"
  '';

  meta = {
    description = "Dual-pane terminal file manager with Vim-style keybindings";
    longDescription = ''
      Rodeo is a terminal file manager inspired by Norton and Midnight
      Commander. It pairs the classic dual-pane layout with Vim-style
      keybindings, a rich preview (syntax highlighting, images, archive
      listings, PDF text, hex dumps), and themes.
    '';
    homepage = "https://github.com/lordgreg/rodeo";
    changelog = "https://github.com/lordgreg/rodeo/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "rodeo";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lordgreg ];
  };
})
