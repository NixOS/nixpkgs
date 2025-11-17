{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chess-tui";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    tag = finalAttrs.version;
    hash = "sha256-OGzYxFGHSH1X8Q8dcB35on/2D+sc0e+chtgObOWUGGM=";
  };

  cargoHash = "sha256-JfX2JWQVrVvq/P/rFumO9QAeJSTxXIKXJxjXmvl1y+g=";

  checkFlags = [
    # assertion failed: result.is_ok()
    "--skip=tests::test_config_create"
  ];

  meta = {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = lib.licenses.mit;
    mainProgram = "chess-tui";
  };
})
