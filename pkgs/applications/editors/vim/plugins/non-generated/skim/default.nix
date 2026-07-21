{
  vimUtils,
  skim,
}:
vimUtils.buildVimPlugin {
  pname = "skim";
  inherit (skim) version;
  src = skim.vim;
}
