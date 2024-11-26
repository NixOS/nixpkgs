{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "f90nml";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshallward";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-nSpVBAS2VvXIQwYK/qVVzEc13bicAQ+ScXpO4Rn2O+8=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "f90nml" ];

  meta = {
    description = "Python module for working with Fortran Namelists";
    mainProgram = "f90nml";
    homepage = "https://f90nml.readthedocs.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
