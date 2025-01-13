{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ha-mqtt-discoverable-cli";
  version = "0.16.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable-cli";
    tag = "v${version}";
    hash = "sha256-VjHsiF4HxGscG1pysxegPyM+Y18CWW06D3WezD+BLss=";
  };

  pythonRelaxDeps = [ "ha-mqtt-discoverable" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [ ha-mqtt-discoverable ];

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [ "ha_mqtt_discoverable_cli" ];

  meta = with lib; {
    description = "CLI for creating Home Assistant compatible MQTT entities that will be automatically discovered";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable-cli";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "hmd";
  };
}
