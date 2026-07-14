{
  vimUtils,
  statix,
}:
vimUtils.buildVimPlugin {
  inherit (statix)
    pname
    src
    meta
    version
    ;

  postPatch = ''
    cd vim-plugin
    substituteInPlace ftplugin/nix.vim --replace-fail statix ${statix}/bin/statix
    substituteInPlace plugin/statix.vim --replace-fail statix ${statix}/bin/statix
  '';
}
