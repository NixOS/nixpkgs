{
  buildPythonPackage,
  meson-python,
  ninja,
  setuptools,
  pkg-config,
  dftd4,
  cffi,
  numpy,
}:

buildPythonPackage {
  inherit (dftd4)
    pname
    version
    src
    meta
    ;

  pyproject = true;

  buildInputs = [ dftd4 ];

  nativeBuildInputs = [
    pkg-config
    ninja
  ];

  build-system = [
    meson-python
    setuptools
  ];

  dependencies = [
    cffi
    numpy
  ];

  preConfigure = ''
    cd python
  '';

  pythonImportsCheck = [ "dftd4" ];
  doCheck = true;
}
