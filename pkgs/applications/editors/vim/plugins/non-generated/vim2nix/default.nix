{
  vimPlugins,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "vim2nix";
  version = "1.0";
  src = ./src;
  dependencies = [ vimPlugins.vim-addon-manager ];
}
