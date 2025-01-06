{
  pkgs ? import ../../../../../.. { },
}:

let
  inherit (pkgs.vimPlugins) nvim-treesitter;

  neovim = pkgs.neovim.override {
    configure.packages.all.start = [ nvim-treesitter ];
  };
in

pkgs.mkShell {
  packages = with pkgs; [
    neovim
    nurl
    python3
  ];

  NVIM_TREESITTER = nvim-treesitter;
}
