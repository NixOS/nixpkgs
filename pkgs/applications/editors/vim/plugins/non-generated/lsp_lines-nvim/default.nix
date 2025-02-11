{
  lib,
  vimUtils,
  fetchFromSourcehut,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "lsp_lines.nvim";
  version = "3.0.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "lsp_lines.nvim";
    rev = "a92c755f182b89ea91bd8a6a2227208026f27b4d";
    hash = "sha256-jHiIZemneQACTDYZXBJqX2/PRTBoxq403ILvt1Ej1ZM=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Neovim diagnostics using virtual lines";
    homepage = "https://git.sr.ht/~whynothugo/lsp_lines.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
