{
  lib,
  vimUtils,
  fetchFromSourcehut,
  nix-update-script,
}:
let
  version = "3.0.0";
in
vimUtils.buildVimPlugin {
  pname = "lsp_lines.nvim";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "lsp_lines.nvim";
    rev = "v${version}";
    hash = "sha256-QsvmPOer7JgO7Y+N/iaNJD7Kmy69gnlV4CeyaQesNvA=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Neovim diagnostics using virtual lines";
    homepage = "https://git.sr.ht/~whynothugo/lsp_lines.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
