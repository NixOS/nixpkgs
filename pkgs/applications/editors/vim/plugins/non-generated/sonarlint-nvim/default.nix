{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
  version = "0-unstable-2025-05-16";

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
    rev = "2aa7a9fd9d8022d1c8d472fb63ce62e021d70130";
    hash = "sha256-RfQthodqF6r24I6EJxlewjYiX3jLAIb/RMAOVnWs73s=";
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
