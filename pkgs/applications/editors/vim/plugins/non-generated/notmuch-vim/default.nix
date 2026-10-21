{
  vimUtils,
  notmuch,
}:
vimUtils.buildVimPlugin {
  inherit (notmuch) pname version;
  src = notmuch.vim;
  meta = {
    inherit (notmuch.meta)
      changelog
      description
      homepage
      license
      platforms
      ;
  };
}
