{ lib
, buildPythonPackage
, autodock-vina
, boost
, swig
, setuptools
, numpy
}:

buildPythonPackage {
  inherit (autodock-vina) pname version src meta;

  format = "pyproject";

  sourceRoot = "${autodock-vina.src.name}/build/python";

  postPatch = ''
    # wildcards are not allowed
    # https://github.com/ccsb-scripps/AutoDock-Vina/issues/176
    substituteInPlace setup.py \
      --replace "python_requires='>=3.5.*'" "python_requires='>=3.5'"

    # setupPyBuildFlags are not applied with `format = "pyproject"`
    substituteInPlace setup.py \
      --replace "= locate_boost()" "= '${lib.getDev boost}/include', '${boost}/lib'"

    # this line attempts to delete the source code
    substituteInPlace setup.py \
      --replace "shutil.rmtree('src')" "..."

    # np.int is deprecated
    # https://github.com/ccsb-scripps/AutoDock-Vina/pull/167 and so on
    substituteInPlace vina/vina.py \
      --replace "np.int" "int"
  '';

  nativeBuildInputs = [
    setuptools
    swig
  ];

  buildInputs = [
    boost
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # upstrem has no tests
  doCheck = false;

  pythonImportsCheck = [
    "vina"
  ];
}
