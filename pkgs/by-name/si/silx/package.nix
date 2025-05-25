{
  python3Packages,
  fetchPypi,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "silx";
  version = "2.2.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XZujZ7VxXMTLkBE4jz1xIA1763Z2yRCVL9E1CjQsVx8=";
  };

  build-system = with python3Packages; [
    cython
    setuptools
  ];

  dependencies = with python3Packages; [
    h5py
    numpy
    matplotlib
    pyopengl
    python-dateutil
    pyside6
    fabio
  ];

  meta = {
    changelog = "https://github.com/silx-kit/silx/blob/main/CHANGELOG.rst";
    description = "Software to support data assessment, reduction and analysis at synchrotron radiation facilities";
    homepage = "https://github.com/silx-kit/silx";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.pmiddend ];
    mainProgram = "silx";
  };

}
