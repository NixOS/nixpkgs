{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "markdown-oxide";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    rev = "v${version}";
    hash = "sha256-PrsTHAlFFeqyZTsoKvoe19P2ed7xDtOlBgoKftFytVw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tower-lsp-0.20.0" = "sha256-QRP1LpyI52KyvVfbBG95LMpmI8St1cgf781v3oyC3S4=";
    };
  };

  meta = with lib; {
    description = "A markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ linsui ];
    mainProgram = "markdown-oxide";
  };
}
