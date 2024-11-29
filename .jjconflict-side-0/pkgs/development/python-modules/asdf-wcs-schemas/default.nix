{
  lib,
  asdf-astropy,
  asdf-coordinates-schemas,
  asdf-standard,
  asdf-transform-schemas,
  asdf,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asdf-wcs-schemas";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf-wcs-schemas";
    rev = "refs/tags/${version}";
    hash = "sha256-4CxKLMYXdNkNwkfFRX3YKkS4e+Z3wQgmz8ogbC4Z1vI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf-coordinates-schemas
    asdf-standard
    asdf-transform-schemas
  ];

  nativeCheckInputs = [
    asdf
    asdf-astropy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asdf_wcs_schemas" ];

  meta = with lib; {
    description = "World Coordinate System (WCS) ASDF schemas";
    homepage = "https://github.com/asdf-format/asdf-wcs-schemas";
    changelog = "https://github.com/asdf-format/asdf-wcs-schemas/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
