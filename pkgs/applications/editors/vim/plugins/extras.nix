{
  lib,
  buildVimPlugin,
  buildNeovimPlugin,
  nodePackages,
  neovim-unwrapped,
}:
let
  luaPackages = neovim-unwrapped.lua.pkgs;
in
self: super:
(
  let
    nodePackageNames = [
      "coc-cmake"
      "coc-docker"
      "coc-emmet"
      "coc-eslint"
      "coc-explorer"
      "coc-flutter"
      "coc-git"
      "coc-go"
      "coc-haxe"
      "coc-highlight"
      "coc-html"
      "coc-java"
      "coc-jest"
      "coc-json"
      "coc-lists"
      "coc-ltex"
      "coc-markdownlint"
      "coc-pairs"
      "coc-prettier"
      "coc-r-lsp"
      "coc-rls"
      "coc-rust-analyzer"
      "coc-sh"
      "coc-smartf"
      "coc-snippets"
      "coc-solargraph"
      "coc-spell-checker"
      "coc-sqlfluff"
      "coc-stylelint"
      "coc-sumneko-lua"
      "coc-tabnine"
      "coc-texlab"
      "coc-tsserver"
      "coc-ultisnips"
      "coc-vetur"
      "coc-vimlsp"
      "coc-vimtex"
      "coc-wxml"
      "coc-yaml"
      "coc-yank"
    ];
    nodePackage2VimPackage =
      name:
      buildVimPlugin {
        pname = name;
        inherit (nodePackages.${name}) version meta;
        src = "${nodePackages.${name}}/lib/node_modules/${name}";
      };
  in
  lib.genAttrs nodePackageNames nodePackage2VimPackage
)
// (
  let
    luarocksPackageNames = [
      "fidget-nvim"
      "gitsigns-nvim"
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
      "rest-nvim"
      "rocks-config-nvim"
      "rtp-nvim"
      "telescope-manix"
      "telescope-nvim"
    ];
    toVimPackage =
      name:
      buildNeovimPlugin {
        luaAttr = luaPackages.${name};
      };
  in
  lib.genAttrs luarocksPackageNames toVimPackage
)
