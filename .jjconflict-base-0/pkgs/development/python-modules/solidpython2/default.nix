{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  ply,
  setuptools,
  poetry-core,
  withOpenSCAD ? false,
  openscad,
}:
buildPythonPackage rec {
  pname = "solidpython2";
  version = "2.1.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "jeff-dh";
    repo = "SolidPython";
    rev = "v${version}";
    hash = "sha256-Tq3hrsC2MmueCqChk6mY/u/pCjF/pFuU2o3K+qw7ImY=";
  };

  # NOTE: this patch makes tests runnable outside the source-tree
  # - it uses diff instead of git-diff
  # - modifies the tests output to resemble the paths resulting from running inside the source-tree
  # - drop the openscad image geneneration tests, these don't work on the nix sandbox due to the need for xserver
  patches = [ ./difftool_tests.patch ];

  propagatedBuildInputs = lib.optionals withOpenSCAD [ openscad ];

  build-system = [
    poetry-core
  ];
  dependencies = [
    ply
    setuptools
  ];
  pythonImportsCheck = [ "solid2" ];
  checkPhase = ''
    runHook preCheck
    python $TMPDIR/source/tests/run_tests.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/jeff-dh/SolidPython";
    description = "A python frontend for solid modelling that compiles to OpenSCAD";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jonboh ];
  };
}
