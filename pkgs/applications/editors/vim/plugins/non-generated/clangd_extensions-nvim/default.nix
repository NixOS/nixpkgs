{
  lib,
  fetchFromSourcehut,
  nix-update-script,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "clangd_extensions.nvim";
  version = "unstable-2024-10-05";

  src = fetchFromSourcehut {
    owner = "~p00f";
    repo = "clangd_extensions.nvim";
    rev = "8f7b72100883e0e34400d9518d40a03f21e4d0a6";
    hash = "sha256-N2YPu2Oa5KBkL8GSp9Al+rxhtNgu7YtxtMuy5BIcnOY=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clangd's off-spec features for neovim's LSP client";
    homepage = "https://git.sr.ht/~p00f/clangd_extensions.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
