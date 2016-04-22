{ pkgs ? import <nixpkgs> { }
, python34Packages ? pkgs.python34Packages
}:

let
  py = python34Packages;

in
py.buildPythonPackage rec {
  name = "fc-util-${version}";
  version = "1.0";
  namePrefix = "";
  src = ./.;
  dontStrip = true;
}
