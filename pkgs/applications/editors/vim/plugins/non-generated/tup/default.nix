{
  lib,
  vimUtils,
  tup,
}:
let
  # Based on the comment at the top of https://github.com/gittup/tup/blob/master/contrib/syntax/tup.vim
  ftdetect = builtins.toFile "tup.vim" ''
    au BufNewFile,BufRead Tupfile,*.tup setf tup
  '';
in
vimUtils.buildVimPlugin {
  inherit (tup) pname version src;
  preInstall = ''
    mkdir -p vim-plugin/syntax vim-plugin/ftdetect
    cp contrib/syntax/tup.vim vim-plugin/syntax/tup.vim
    cp "${ftdetect}" vim-plugin/ftdetect/tup.vim
    cd vim-plugin
  '';
  meta.maintainers = with lib.maintainers; [ enderger ];
}
