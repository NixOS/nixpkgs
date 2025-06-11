{
  lib,
  fetchFromSourcehut,
  nix-update-script,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "clangd_extensions.nvim";
  version = "0-unstable-2025-01-27";

  src = fetchFromSourcehut {
    owner = "~p00f";
    repo = "clangd_extensions.nvim";
    rev = "db28f29be928d18cbfb86fbfb9f83f584f658feb";
    hash = "sha256-XdA638W0Zb85v5uAUNpvUiiQXGKOM2xykD2ClLk8Qpo=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clangd's off-spec features for neovim's LSP client";
    homepage = "https://git.sr.ht/~p00f/clangd_extensions.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
