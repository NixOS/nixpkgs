{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ron-lsp";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jasonjmcghee";
    repo = "ron-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+fMV2J6S6+vRmdSsS6TtrCGxxOw+dgL4dEJWsJpB5bY=";
  };

  cargoHash = "sha256-vJ0+M0Mg2ONfGcKqGs2hffMAdcgawra1cHWPeaqpo1w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RON, Rusty Object Notation, Language Server";
    longDescription = ''
      An LSP and CLI for RON files that provides autocomplete,
      diagnostics, go to definition, code actions, and hover support
      based on Rust type annotations
    '';
    homepage = "https://github.com/jasonjmcghee/ron-lsp";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
    mainProgram = "ron-lsp";
  };
})
