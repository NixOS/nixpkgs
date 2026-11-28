{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-somafm";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_somafm";
    hash = "sha256-d7yr3jbZ28Sj5I06i34xvxZtXnynW5f6+Iem5lQ6EZ4=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_somafm" ];

  meta = {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from SomaFM";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nickhu ];
  };
})
