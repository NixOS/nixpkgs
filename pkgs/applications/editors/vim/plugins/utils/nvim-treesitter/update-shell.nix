{
  pkgs ? import ../../../../../../.. { },
}:

with pkgs;

let
  pythonWithPackages = python3.withPackages (
    ps: with ps; [
      requests
    ]
  );
  luaWithPackages = luajit.withPackages (
    ps: with ps; [
      json
    ]
  );
in

mkShell {
  packages = [
    nurl
    pythonWithPackages
    luaWithPackages
  ];
}
