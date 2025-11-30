{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2025-11-04";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "b8aade3a0626f2bc1d3cd79affcd7da9f47f7ab1";
    hash = "sha256-gaK2aemMX4fzH85idIPuVZ1+ay5vCNqgxU15J4Jz5wU=";
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
