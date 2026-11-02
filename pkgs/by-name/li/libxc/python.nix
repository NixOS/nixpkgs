{
  buildPythonPackage,
  lib,
  libxc,
  setuptools,
  cmake,
  numpy,
}:

buildPythonPackage {
  pname = "pylibxc";
  inherit (libxc)
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
