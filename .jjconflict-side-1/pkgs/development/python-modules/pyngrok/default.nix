{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mhKFLWP76iUaRj2FXVEO1QQBoC5ptKeinIbRtQxeOHU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = {
    description = "Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
