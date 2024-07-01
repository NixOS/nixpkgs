{ lib
, python3
, fetchPypi
}:

let
  pname = "csvkit";
  version = "2.0.0";
  pythonEnv = python3;
in
pythonEnv.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MR8heHYVqRZWiX4hfGKrJshEbWcwm2G9AT40WzWBb98=";
  };

  propagatedBuildInputs = with pythonEnv.pkgs; [
    agate
    agate-excel
    agate-dbf
    agate-sql
    setuptools # csvsql imports pkg_resources
  ];

  nativeCheckInputs = with pythonEnv.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "csvkit"
  ];

  disabledTests = [
    # Tries to compare CLI output - and fails!
    "test_decimal_format"
  ];

  meta = {
    homepage = "https://github.com/wireservice/csvkit";
    description = "Suite of command-line tools for converting to and working with CSV";
    changelog = "https://github.com/wireservice/csvkit/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
