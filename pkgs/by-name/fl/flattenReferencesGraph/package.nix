{
  callPackage,
  nix-gitignore,
  python3Packages,
}:
let
  helpers = callPackage ./helpers.nix { };
  pythonPackages = python3Packages;

in
pythonPackages.buildPythonApplication {
  version = "0.1.0";
  format = "pyproject";
  pname = "flatten-references-graph";

  # Note: this uses only ./src/.gitignore
  src = nix-gitignore.gitignoreSource [ ] ./src;

  build-system = with pythonPackages; [
    setuptools
  ];

  dependencies = with pythonPackages; [
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
