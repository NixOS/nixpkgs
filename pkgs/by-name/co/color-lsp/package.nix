{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "color-lsp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "color-lsp";
    rev = "v${version}";
    hash = "sha256-U0pTzW2PCgMxVsa1QX9MC249PXXL2KvRSN1Em2WvIeI=";
  };

  cargoHash = "sha256-etK+9fcKS+y+0C36vJrMkQ0yyVSpCW/DLKg4nTw3LrE=";

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
