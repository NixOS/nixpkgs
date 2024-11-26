{
  lib,
  buildPythonPackage,
  colorama,
  cpe,
  fetchFromGitHub,
  jsonschema,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
  simplejson,
  stix2-patterns,
}:

buildPythonPackage rec {
  pname = "stix2-validator";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-stix-validator";
    rev = "refs/tags/v${version}";
    hash = "sha256-OI1SXILyCRGl1ZsoyYDl+/RsBhTP24eqECtW3uazS2k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    cpe
    jsonschema
    python-dateutil
    requests
    simplejson
    stix2-patterns
  ];

  # Tests need more work
  # Exception: Could not deserialize ATN with version  (expected 4).
  doCheck = false;

  # nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Validator for STIX 2.0 JSON normative requirements and best practices";
    homepage = "https://github.com/oasis-open/cti-stix-validator/";
    changelog = "https://github.com/oasis-open/cti-stix-validator/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
