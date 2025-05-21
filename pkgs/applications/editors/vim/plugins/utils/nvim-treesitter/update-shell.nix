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
in

mkShell {
  packages = [
    nurl
    pythonWithPackages
  ];
}
