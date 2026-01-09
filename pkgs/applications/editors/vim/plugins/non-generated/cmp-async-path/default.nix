{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2026-01-05";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "a14d3a9c7f303551a0b8c64a0e4e6527ce39a8a2";
    hash = "sha256-QOa2Oke3p5wGhTJ4TjcgTUphb0OdDUwmw8MiYp2LkhA=";
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
