{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "rainbow-delimiters.nvim";
  version = "0.11.0";

  src = fetchFromGitLab {
    owner = "HiPhish";
    repo = "rainbow-delimiters.nvim";
    tag = "v${version}";
    hash = "sha256-zQgnNN8QvboOHWaMcLw1uRt/9AxV1asvTnpCcJ/qVS4=";
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
