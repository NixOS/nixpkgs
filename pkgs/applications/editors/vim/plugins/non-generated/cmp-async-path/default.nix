{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "d6d1ffa2075039632a2d71e8fa139818e15ac757";
    hash = "sha256-MZFpNPtSDMZNkfoz+3ZcDxLb8PvDtm9nb1dE0CbYIPQ=";
  };

  checkInputs = [ vimPlugins.nvim-cmp ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Nvim-cmp source for filesystem paths with async processing";
    homepage = "https://codeberg.org/FelipeLema/cmp-async-path/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
