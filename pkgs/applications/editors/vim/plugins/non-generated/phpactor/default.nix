{
  vimUtils,
  phpactor,
}:
vimUtils.buildVimPlugin {
  inherit (phpactor)
    pname
    src
    meta
    version
    ;
  postPatch = ''
    substituteInPlace plugin/phpactor.vim \
      --replace-fail "g:phpactorpath = expand('<sfile>:p:h') . '/..'" "g:phpactorpath = '${phpactor}'"
  '';
}
