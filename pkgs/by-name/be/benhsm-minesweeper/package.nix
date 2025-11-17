{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "benhsm-minesweeper";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "benhsm";
    repo = "minesweeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ahevo/dogjcJ6GRqVZKYapy1x16F+U6vEsgpt2RdiE=";
  };

  vendorHash = "sha256-UvvoL7Us201B13M4vwOZEhSB0slAzXCs+9wzJIDictQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple terminal-based implementation of Minesweeper";
    homepage = "https://github.com/benhsm/minesweeper";
    changelog = "https://github.com/benhsm/minesweeper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "minesweeper";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
