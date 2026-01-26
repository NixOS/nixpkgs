{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2026-01-09";

  src = fetchFromCodeberg {
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "9c2374deb32c2bec8b27e928c6f57090e9a875d2";
    hash = "sha256-obi3c5dRfPhYsNJk33lCwTtXWuwOyzEqKOpUk3z7Bxk=";
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
