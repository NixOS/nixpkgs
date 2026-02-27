{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "color-lsp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "color-lsp";
    rev = "v${version}";
    hash = "sha256-p58rAVznBzhBv7gVvaEjMpCrk9kFuEjUvY6U4uMXUE8=";
  };

  cargoHash = "sha256-o/me2LIv6qvxOuHUnyv8+GcfoJlmdFymJkJMuOlC1Nw=";

  # Only build the color-lsp binary, not the zed extension
  cargoBuildFlags = [
    "-p"
    "color-lsp"
  ];
  cargoTestFlags = [
    "-p"
    "color-lsp"
  ];

  meta = {
    description = "A document color language server supporting HEX, RGB, HSL, and named colors";
    homepage = "https://github.com/huacnlee/color-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tonybutt
      matthiasbeyer
    ];
    mainProgram = "color-lsp";
  };
}
