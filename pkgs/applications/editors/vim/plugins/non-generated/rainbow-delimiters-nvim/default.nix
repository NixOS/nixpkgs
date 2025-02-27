{
  lib,
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.8.0";
in
vimUtils.buildVimPlugin {
  pname = "rainbow-delimiters.nvim";
  inherit version;

  src = fetchFromGitHub {
    owner = "HiPhish";
    repo = "rainbow-delimiters.nvim";
    tag = "v${version}";
    hash = "sha256-40NE1+BFG6OPcHKGejfltuTANB/GTIPn1BfvAB55t9Q=";
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
