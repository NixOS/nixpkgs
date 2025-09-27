{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-IcNPtyYXNLWtZDeVPWfLzKeVv6PGHYTb/mvVQ5uAiTE=";
  };

  cargoHash = "sha256-epFrVie97VUGGlr4cNKzZCbUpxCgG/kmJPd1JWen6j0=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
