{
  vimUtils,
  skim,
}:
vimUtils.buildVimPlugin {
  pname = "skim";
  inherit (skim) version;
  src = skim.vim;

  meta = {
    inherit (skim.meta)
      description
      homepage
      changelog
      license
      maintainers
      ;
  };
}
