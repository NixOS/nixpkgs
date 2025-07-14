{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2025-04-13";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "0ed1492f59e730c366d261a5ad822fa37e44c325";
    hash = "sha256-J1Iw7yNfvWq7Jul25Eyx4qk9lSiLpZt4TRvTYi1DXtk=";
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
