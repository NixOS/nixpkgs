{
  pkgs ? import ../../../../../../.. { },
}:

with pkgs;

let
  luaWithPackages = luajit.withPackages (
    ps: with ps; [
      json
    ]
  );
in

mkShell {
  packages = [
    nurl
    python3
    luaWithPackages
  ];
  env.NVIM_TREESITTER = vimPlugins.nvim-treesitter;
}
