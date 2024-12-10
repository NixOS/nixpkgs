# SolidPython is an unmaintained library with old dependencies.
{
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  lib,
  pythonRelaxDepsHook,

  poetry-core,
  prettytable,
  pypng,
  ply,
  setuptools,
  euclid3,
}:
buildPythonPackage rec {
  pname = "solidpython";
  version = "1.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SolidCode";
    repo = "SolidPython";
    rev = "d962740d600c5dfd69458c4559fc416b9beab575";
    hash = "sha256-3fJta2a5c8hV9FPwKn5pj01aBtsCGSRCz3vvxR/5n0Q=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    ply
    setuptools
    euclid3

    prettytable
  ];

  pythonRelaxDeps = [
    # SolidPython has PrettyTable pinned to a hyper-specific version due to
    # some ancient bug with Poetry. They aren't interested in unpinning because
    # SolidPython v1 seems to be deprecated in favor of v2:
    # https://github.com/SolidCode/SolidPython/issues/207
    "PrettyTable"
  ];

  pythonRemoveDeps = [
    # The pypng dependency is only used in an example script.
    "pypng"
  ];

  pythonImportsCheck = [
    "solid"
  ];

  meta = with lib; {
    description = "Python interface to the OpenSCAD declarative geometry language";
    homepage = "https://github.com/SolidCode/SolidPython";
    changelog = "https://github.com/SolidCode/SolidPython/releases/tag/v${version}";
    maintainers = with maintainers; [ jfly ];
    license = licenses.lgpl21Plus;
  };
}
