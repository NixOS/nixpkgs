{
  callPackage,
  lib,
  nix-gitignore,
  python3Packages,
}:
let
  inherit (lib) fileset;
  helpers = callPackage ./helpers.nix { };
  pythonPackages = python3Packages;
in
pythonPackages.buildPythonApplication {
  version = "0.1.0";
  pname = "flatten-references-graph";

  src = fileset.toSource {
    root = ./src;
    fileset = fileset.difference ./src (fileset.maybeMissing ./src/__pycache__);
  };

  propagatedBuildInputs = with pythonPackages; [
    igraph
    toolz
  ];

  doCheck = true;

  checkPhase = ''
    ${helpers.unittest}/bin/unittest
  '';

  passthru = {
    dev-shell = callPackage ./dev-shell.nix { };
  };
}
