{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt-tui";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-JXQRtjxSj/aawYnfbTGp55K3ydvFXqh/6ot+B/aL/ak=";
  };

  cargoHash = "sha256-Xlk+GEqW2fACBlBBLnDcG4uzzZ+wLQ9rryw4vACZWGM=";

  meta = {
    description = "TUI Application to manage Obsidian notes directly from the terminal";
    homepage = "https://github.com/erikjuhani/basalt";
    license = lib.licenses.mit;
    mainProgram = "basalt";
    maintainers = [ lib.maintainers.cardboardcpu ];
  };
})
