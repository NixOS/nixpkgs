{ lib
, python3
, fetchPypi
}:

let
  pname = "csvkit";
  version = "1.1.1";
  pythonEnv = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };
in
pythonEnv.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vt23t49rIq2+1urVrV3kv7Md0sVfMhGyorO2VSkEkiM=";
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
    description = "A suite of command-line tools for converting to and working with CSV";
    changelog = "https://github.com/wireservice/csvkit/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
