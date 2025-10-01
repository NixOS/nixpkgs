{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
  version = "0-unstable-2025-09-18";

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
    rev = "dc5702556f90eedce587233f3c1a0ae671ea3648";
    hash = "sha256-IBXQ9ijAG8TdnwkSTNbBtzziQC5bbCbkAmC8gM7G5E4=";
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
