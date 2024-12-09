{
  callPackage,
  lib,
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
    fileset = fileset.unions [
      ./src/.flake8
      ./src/flatten_references_graph
      ./src/setup.py
    ];
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
