{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-bV1elEO1518LVLwNDN5pzjxRgcG34K1XUsK7fTw8h+8=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    paho-mqtt
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomqtt" ];

  pytestFlagsArray = [
    "-m"
    "'not network'"
  ];

  meta = with lib; {
    description = "Idiomatic asyncio MQTT client, wrapped around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/aiomqtt";
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
