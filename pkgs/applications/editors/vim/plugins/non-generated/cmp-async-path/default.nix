{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-async-path";
  version = "0-unstable-2026-01-28";

  src = fetchFromCodeberg {
    owner = "FelipeLema";
    repo = "cmp-async-path";
    rev = "f8af3f726e07f2e9d37672eaa9102581aefce149";
    hash = "sha256-ALMK7TnEB7/UZibVgOl4r6/gYsHCo6YAZcAR536VL4g=";
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
