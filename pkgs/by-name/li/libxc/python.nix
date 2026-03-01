{
  buildPythonPackage,
  lib,
  libxc,
  setuptools,
  cmake,
  numpy,
}:

buildPythonPackage {
  inherit (libxc)
    pname
    version
    src
    patches
    meta
    nativeBuildInputs
    ;

  pyproject = true;

  build-system = [
    setuptools
    cmake
  ];

  dependencies = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "pylibxc" ];
}
