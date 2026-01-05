{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
    rev = "36f4fcee5b0cd3ddae1aa10225ddf40100dbb6a4";
    hash = "sha256-UhCb7Glxsd/byGRQ6eLK0dAQHNuShWzJMCxM+RkhFyw=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://gitlab.com/schrieveslaach/sonarlint.nvim";
    description = "Extensions for the built-in Language Server Protocol support in Neovim for sonarlint-language-server";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.sinics ];
  };
}
