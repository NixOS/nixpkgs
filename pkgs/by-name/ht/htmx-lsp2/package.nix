{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "htmx-lsp2";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "htmx-lsp2";
    tag = "v${version}";
    hash = "sha256-Okd4jPCZvVDWIXj7aRLRnrUOT0mD3rBr6VDEgoWXRZE=";
  };

  cargoHash = "sha256-NDse9cgwnPDziVgPz7KBwoZcttypSB98EGoK4zN4tG4=";

  meta = {
    description = "Language server implementation for HTMX, a successor to htmx-lsp";
    homepage = "https://github.com/uros-5/htmx-lsp2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamjhf ];
    mainProgram = "htmx-lsp2";
  };
}
