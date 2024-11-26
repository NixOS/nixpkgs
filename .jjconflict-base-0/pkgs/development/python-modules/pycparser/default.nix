{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.22";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SRyL6cBA9TkPW/RKWwd1K9B/Vu35kjgbBccBQ57sEPY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];
  disabled = pythonOlder "3.8";

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = with lib; {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
