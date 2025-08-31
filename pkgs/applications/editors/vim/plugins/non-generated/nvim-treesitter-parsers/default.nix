{
  lib,
  vimPlugins,
}:
lib.recurseIntoAttrs vimPlugins.nvim-treesitter.grammarPlugins
