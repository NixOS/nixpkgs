{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ron-lsp";
  version = "0.1.1";

  # https://github.com/jasonjmcghee/ron-lsp
  src = fetchFromGitHub {
    owner = "jasonjmcghee";
    repo = "ron-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c+cJrXINuoK+NR1rMSrOeZqZzrEcg/brSTKSTu5mNr4=";
  };

  cargoHash = "sha256-Auq1XpZVDY9coxYEeeMNotsltR5e0RuZKQXbgi0hHUM=";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A RON, Rust Object Notation, Language Server";
    longDescription = "An LSP and CLI for RON files that provides autocomplete, diagnostics, go to definition, code actions, and hover support based on Rust type annotations";
    homepage = "https://github.com/jasonjmcghee/ron-lsp";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
    mainProgram = "ron-lsp";
  };
})
