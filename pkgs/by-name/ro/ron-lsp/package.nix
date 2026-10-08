{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ron-lsp";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jasonjmcghee";
    repo = "ron-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7mmwoAvUVf86xxTXuI6Zc44nrPJ4yRz+rmwJ61/Wil8=";
  };

  cargoHash = "sha256-oysc13+FNF+IHVGYFV5MP5smaK9TtXXgDOhn7QmMPqs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RON, Rusty Object Notation, Language Server";
    longDescription = ''
      An LSP and CLI for RON files that provides autocomplete,
      diagnostics, go to definition, code actions, and hover support
      based on Rust type annotations
    '';
    homepage = "https://github.com/jasonjmcghee/ron-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
    mainProgram = "ron-lsp";
  };
})
