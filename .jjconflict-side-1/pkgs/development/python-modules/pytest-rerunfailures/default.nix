{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  packaging,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "15.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LZrHuvWfTBOscwtH9vqA51XRugWB2kXOMLcvs1QrRHQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
