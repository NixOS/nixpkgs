{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-OAYQ/XtM4AHfbpA+gVa/AjB3tyMtvgykpHc39WaU2CI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "chess" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    description = "Chess library with move generation, move validation, and support for common formats";
    homepage = "https://github.com/niklasf/python-chess";
    changelog = "https://github.com/niklasf/python-chess/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ smancill ];
  };
}
