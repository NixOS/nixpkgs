{
  vimUtils,
  teamtype,
}:
vimUtils.buildVimPlugin rec {
  inherit (teamtype)
    pname
    version
    src
    meta
    ;

  sourceRoot = "${src.name}/nvim-plugin";
}
