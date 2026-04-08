{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "rainbow-delimiters.nvim";
  version = "0.12.0";

  src = fetchFromGitLab {
    owner = "HiPhish";
    repo = "rainbow-delimiters.nvim";
    tag = "v${version}";
    hash = "sha256-q4cBvF8d5h+BM1LTm5aq02OBVmwSUb9rC1smHlxbRzg=";
  };

  nvimSkipModules = [
    # rainbow-delimiters.types.lua
    "rainbow-delimiters.types"
    # Test that requires an unpackaged dependency
    "rainbow-delimiters._test.highlight"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rainbow delimiters for Neovim with Tree-sitter";
    homepage = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
