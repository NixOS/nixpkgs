{
  lib,
  vimUtils,
  meson,
}:
vimUtils.buildVimPlugin {
  inherit (meson) pname version src;
  preInstall = "cd data/syntax-highlighting/vim";
  meta.maintainers = with lib.maintainers; [ vcunat ];
}
