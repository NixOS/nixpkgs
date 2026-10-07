{
  lib,
  anyascii,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  google-cloud-storage,
  legacy-cgi,
  mock,
  pillow,
  pymongo,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "filedepot";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "depot";
    tag = finalAttrs.version;
    hash = "sha256-oDnGA2prxYUkC90ewryeJXTXED59vcZGHU9D0QiopFM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyascii
    legacy-cgi
    google-cloud-storage
  ];

  nativeCheckInputs = [
    flaky
    mock
    pillow
    pymongo
    pytestCheckHook
    requests
    sqlalchemy
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'depot._pillow_compat'
    "tests/test_fields_sqlalchemy.py"
    # The examples have tests
    "examples"
    # Missing dependencies (TurboGears2 and ming)
    "tests/test_fields_ming.py"
    "tests/test_wsgi_middleware.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [ "test_notexisting" ];

  pythonImportsCheck = [ "depot" ];

  meta = {
    description = "Toolkit for storing files and attachments in web applications";
    homepage = "https://github.com/amol-/depot";
    changelog = "https://github.com/amol-/depot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
