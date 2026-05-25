{
  lib,
  vimUtils,
  meson,
}:
vimUtils.buildVimPlugin {
  inherit (meson) pname version src;
  preInstall = "cd data/syntax-highlighting/vim";

  meta = {
    inherit (meson.meta)
      homepage
      description
      mainProgram
      longDescription
      license
      platforms
      ;
    maintainers = with lib.maintainers; [ vcunat ];
  };
}
