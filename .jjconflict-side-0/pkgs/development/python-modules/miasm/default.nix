{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  future,
  gcc,
  llvmlite,
  parameterized,
  pycparser,
  pyparsing,
  z3-solver,
  setuptools,
}:
let
  commit = "cbc722eed8dc807955bd46f84886ae74d161dd0c";
in
buildPythonPackage {
  pname = "miasm";
  version = "0.1.5-unstable-2024-08-20";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "cea-sec";
    repo = "miasm";
    rev = commit;
    hash = "sha256-Ot11QuMtaJ8OQDAUgV3zVxTNp0kKc0Y9EXRZD96Caow=";
  };

  patches = [
    #  Use a valid semver as now required by setuptools
    ./0001-setup.py-use-valid-semver.patch

    # Removes the (unfree) IDAPython dependency
    ./0002-core-remove-IDAPython-dependency.patch
  ];

  dependencies = [
    future
    llvmlite
    parameterized
    pycparser
    pyparsing
    z3-solver
  ];

  buildInputs = [ gcc ];

  pythonImportsCheck = [ "miasm" ];

  meta = {
    description = "Reverse engineering framework in Python";
    homepage = "https://github.com/cea-sec/miasm";
    changelog = "https://github.com/cea-sec/miasm/blob/${commit}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ msanft ];
  };
}
