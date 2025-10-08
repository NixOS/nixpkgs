{
  vimUtils,
  ethersync,
}:
vimUtils.buildVimPlugin rec {
  inherit (ethersync)
    pname
    version
    src
    meta
    ;

  sourceRoot = "${src.name}/nvim-plugin";
}
