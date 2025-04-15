{
  lib,
  buildNeovimPlugin,
  neovim-unwrapped,
}:
final: prev:
let
  luaPackages = neovim-unwrapped.lua.pkgs;

  luarocksPackageNames = [
    "fidget-nvim"
    "gitsigns-nvim"
    "grug-far-nvim"
    "image-nvim"
    "lsp-progress-nvim"
    "lualine-nvim"
    "luasnip"
    "lush-nvim"
    "lz-n"
    "lze"
    "lzextras"
    "lzn-auto-require"
    "middleclass"
    "mini-test"
    "neorg"
    "neotest"
    "nui-nvim"
    "nvim-cmp"
    "nvim-nio"
    "nvim-web-devicons"
    "oil-nvim"
    "orgmode"
    "papis-nvim"
    "plenary-nvim"
    "rest-nvim"
    "rocks-config-nvim"
    "rtp-nvim"
    "telescope-manix"
    "telescope-nvim"
  ];
in
lib.genAttrs luarocksPackageNames (
  name:
  buildNeovimPlugin {
    luaAttr = luaPackages.${name};
  }
)
