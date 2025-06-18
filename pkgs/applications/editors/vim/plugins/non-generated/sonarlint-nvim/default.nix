{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
    rev = "060df51352f9fb876d4ff43b8cd4b669a6bdfd89";
    hash = "sha256-2MAi0nZIvAly+5p5fWKMi3tGSzMJgMnAzWnsr0rt+NM=";
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
