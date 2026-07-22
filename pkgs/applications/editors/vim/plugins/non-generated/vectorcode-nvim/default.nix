{
  lib,
  vimUtils,
  vectorcode,
  vimPlugins,
}:
let
  inherit (vectorcode) src version;
in
vimUtils.buildVimPlugin {
  inherit src version;

  pname = "vectorcode.nvim";

  # nixpkgs-update: no auto update
  # This is built from the same source as vectorcode and will rebuild automatically

  sourceRoot = "${src.name}/plugin";

  dependencies = [
    vimPlugins.plenary-nvim
  ];

  buildInputs = [ vectorcode ];

  postPatch = ''
    cp -r ../lua .
  '';

  checkInputs = [
    vimPlugins.codecompanion-nvim
  ];

  meta = {
    description = "Index and navigate your code repository using vectorcode";
    homepage = "https://github.com/Davidyz/VectorCode/blob/main/docs/neovim/README.md";
    inherit (vectorcode.meta) changelog license;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
