{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "gmqtt";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vt/se6wmtrTOHwxMMs/z1mNSalTIgtMj1BVg/DubRKI=";
  };

  build-system = [ setuptools ];

  # Tests require local socket connection which is forbidden in the sandbox
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];
  pythonImportsCheck = [ "gmqtt" ];

  meta = {
    description = "Python MQTT v5.0 async client";
    homepage = "https://github.com/wialon/gmqtt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
