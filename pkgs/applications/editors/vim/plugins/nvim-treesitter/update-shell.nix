{
  pkgs ? import ../../../../../.. { },
}:

with pkgs;

let
  inherit (vimPlugins) nvim-treesitter;

  neovim = pkgs.neovim.override {
    configure.packages.all.start = [ nvim-treesitter ];
  };
in

mkShell {
  packages = [
    neovim
    nurl
    python3
  ];

  NVIM_TREESITTER = nvim-treesitter;
}
