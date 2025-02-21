{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-oxide";
  version = "0.23.1-unstable-2024-07-20";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    rev = "0f1542a54a44de8313087f6c60e6ecd54f52ede5";
    hash = "sha256-zxJZnhN2cN3sNd+PHi2jYuHDDA4ekEVIi3X52Z/8TGM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tower-lsp-0.20.0" = "sha256-QRP1LpyI52KyvVfbBG95LMpmI8St1cgf781v3oyC3S4=";
    };
  };

  meta = with lib; {
    description = "Markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [
      linsui
      jukremer
    ];
    mainProgram = "markdown-oxide";
  };
}
