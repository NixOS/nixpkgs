{
  symlinkJoin,
}:
final: prev: {

  corePlugins = symlinkJoin {
    name = "core-vim-plugins";
    paths = with final; [
      # plugin managers
      lazy-nvim
      mini-deps
      packer-nvim
      vim-plug

      # core dependencies
      plenary-nvim

      # popular plugins
      mini-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      vim-airline
      vim-fugitive
      vim-surround
    ];

    meta.description = "Collection of popular vim plugins (for internal testing purposes)";
  };

}
