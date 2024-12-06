{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "markdown-oxide";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    rev = "v${version}";
    hash = "sha256-ULoPL+bkYjhfLMKwjbZp8tP8/+M/lWylqUWmNTBvnuM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tower-lsp-0.20.0" = "sha256-QRP1LpyI52KyvVfbBG95LMpmI8St1cgf781v3oyC3S4=";
    };
  };

  meta = {
    description = "Markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      linsui
      jukremer
    ];
    mainProgram = "markdown-oxide";
  };
}
