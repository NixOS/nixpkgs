{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ha-mqtt-discoverable-cli";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-miFlrBmxVuIJjpsyYnbQt+QAGSrS4sHlJpCmxouM2Wc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ha-mqtt-discoverable
  ];

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [
    "ha_mqtt_discoverable_cli"
  ];

  meta = with lib; {
    description = "CLI for creating Home Assistant compatible MQTT entities that will be automatically discovered";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable-cli";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable-cli/releases/tag/v0.2.1";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "hmd";
  };
}
