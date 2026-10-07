{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutesync";
  version = "0.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mutesync";
    inherit (finalAttrs) version;
    hash = "sha256-DJcpsJKyNIikSd1PlUbkfUKzz5kqe4lW7xhxmvDA49M=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [ "mutesync" ];

  meta = {
    description = "Python module for interacting with mutesync buttons";
    homepage = "https://github.com/currentoor/pymutesync";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
