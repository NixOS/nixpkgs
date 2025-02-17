{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "rainbow-delimiters.nvim";
  version = "unstable-2025-01-12";

  src = fetchFromGitLab {
    owner = "HiPhish";
    repo = "rainbow-delimiters.nvim";
    rev = "85b80abaa09cbbc039e3095b2f515b3cf8cadd11";
    hash = "sha256-zWHXYs3XdnoszqOFY3hA2L5mNn1a44OAeKv3lL3EMEw=";
  };

  nvimSkipModule = [
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
