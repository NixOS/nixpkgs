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
  format = "setuptools";
  pname = "flatten-references-graph";

  # Note: this uses only ./src/.gitignore
  src = nix-gitignore.gitignoreSource [ ] ./src;

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
