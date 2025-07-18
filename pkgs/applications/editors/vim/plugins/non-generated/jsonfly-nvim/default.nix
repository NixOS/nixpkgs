{
  lib,
  fetchFromGitea,
  vimUtils,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "jsonfly.nvim";
  version = "0-unstable-2025-06-07";

  src = fetchFromGitea {
    domain = "git.myzel394.app";
    owner = "Myzel394";
    repo = "jsonfly.nvim";
    rev = "db4394d856059d99d82ea2c75d033721e9dcb1fc";
    hash = "sha256-PmYm+vZ0XONoHUo08haBozbXRpN+/LAlr6Fyg7anTNw=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search blazingly fast for JSON / XML / YAML keys via Telescope";
    homepage = "https://git.myzel394.app/Myzel394/jsonfly.nvim";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ myzel394 ];
  };
}
