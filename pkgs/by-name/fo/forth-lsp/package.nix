{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "forth-lsp";
  version = "0.4.1-unstable-2025-12-18";

  src = fetchFromGitHub {
    owner = "AlexanderBrevig";
    repo = "forth-lsp";
    rev = "22988d65b80f5b57e4157c9bf3fb3e9c0dafb3aa";
    hash = "sha256-hj0fsUdP67/XPzxce44kdl8dKi8XYU++qjo7z0MX4Xs=";
  };

  cargoHash = "sha256-lvQIzRNpO0MugybUBjaFr2gYtsk5o7H9+jBId86ZEgU=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "LSP for the Forth programming language";
    mainProgram = "forth-lsp";
    homepage = "https://github.com/AlexanderBrevig/forth-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ agx ];
  };
}
