{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchPypi,
  werkzeug,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "pytest_localserver";
    inherit version;
    hash = "sha256-+voCggk37n050B11D9Bc6xl/xfPIlfgbysOCbbCQh+0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ werkzeug ];

  optional-dependencies = {
    smtp = [ aiosmtpd ];
  };

  # All tests access network: does not work in sandbox
  doCheck = false;

  pythonImportsCheck = [ "pytest_localserver" ];

  meta = with lib; {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = "https://github.com/pytest-dev/pytest-localserver";
    changelog = "https://github.com/pytest-dev/pytest-localserver/blob/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
