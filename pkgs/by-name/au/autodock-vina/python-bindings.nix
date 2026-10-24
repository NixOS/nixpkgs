{
  lib,
  buildPythonPackage,
  autodock-vina,

  # build-system
  setuptools,

  # nativeBuildInputs
  swig,

  # dependencies
  numpy,
}:

let
  inherit (autodock-vina) boost;
in

buildPythonPackage {
  pname = "vina";
  inherit (autodock-vina)
    version
    src
    ;
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${autodock-vina.src.name}/build/python";

  postPatch =
    # setupPyBuildFlags are not applied with `pyproject = true`
    ''
      substituteInPlace setup.py \
        --replace-fail \
          "= locate_boost()" \
          "= '${lib.getDev boost}/include', '${lib.getLib boost}/lib'"
    ''
    # this line attempts to delete the source code
    + ''
      substituteInPlace setup.py \
        --replace-fail "shutil.rmtree('src')" "..."
    '';

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    swig
  ];

  buildInputs = [
    boost
  ];

  dependencies = [
    numpy
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "vina"
  ];

  meta = removeAttrs autodock-vina.meta [ "mainProgram" ] // {
    description = "Python bindings for AutoDock Vina, an open-source molecular docking engine";
  };
}
