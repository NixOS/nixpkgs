{
  lib,
  vimUtils,
  meson,
}:
vimUtils.buildVimPlugin {
  inherit (meson) pname version src;
  preInstall = "cd data/syntax-highlighting/vim";

  meta = {
    description = "Vim plugin for meson providing syntax highlighting";
    inherit (meson.meta)
      homepage
      license
      platforms
      ;
    maintainers = with lib.maintainers; [ vcunat ];
  };
}
