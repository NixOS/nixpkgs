{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
  version = "0-unstable-2025-04-18";

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
    rev = "0b78f1db800f9ba76f81de773ba09ce2222bdcc2";
    hash = "sha256-EUwuIFFe4tmw8u6RqEvOLL0Yi8J5cLBQx7ICxnmkT4k=";
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
