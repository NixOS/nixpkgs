{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "csvkit";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uR6PWkhYiMPFFbFcwlJc5L5c/NT0dm6tgxE+eHtf1TY=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    agate
    agate-excel
    agate-dbf
    agate-sql
    setuptools # csvsql imports pkg_resources
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "csvkit" ];

  disabledTests = [
    # Tries to compare CLI output - and fails!
    "test_decimal_format"
  ];

  meta = {
    homepage = "https://github.com/wireservice/csvkit";
    description = "Suite of command-line tools for converting to and working with CSV";
    changelog = "https://github.com/wireservice/csvkit/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
