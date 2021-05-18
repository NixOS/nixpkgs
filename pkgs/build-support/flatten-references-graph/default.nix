{
  bash,
  nix-gitignore,
  python3Packages,
  writers
}:
let
  helpers = import ./helpers.nix { inherit bash python3Packages writers; };
  pythonPackages = python3Packages;

in pythonPackages.buildPythonApplication {
  version = "0.1.0";
  pname = "flatten-references-graph";

  # Note: this uses only ./src/.gitignore
  src = nix-gitignore.gitignoreSource [] ./src;

  propagatedBuildInputs = with pythonPackages; [
    python-igraph
    toolz
  ];

  doCheck = true;

  checkPhase = ''
    ${helpers.lint}/bin/lint
    ${helpers.unittest}/bin/unittest
  '';
}
