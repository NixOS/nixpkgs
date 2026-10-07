{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ihcsdk";
  version = "2.8.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dingusdk";
    repo = "PythonIhcSdk";
    tag = "v${version}";
    hash = "sha256-yFCLxe+BzG6+blEEmUHX+KZZVokyLxw7GD7q/GOEzGU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
  ];

  pythonImportsCheck = [ "ihcsdk" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/dingusdk/PythonIhcSdk/releases/tag/v${version}";
    description = "SDK for connection to the LK IHC Controller";
    homepage = "https://github.com/dingusdk/PythonIhcSdk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
