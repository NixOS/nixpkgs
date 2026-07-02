{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ha-mqtt-discoverable-cli";
  version = "0.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "ha-mqtt-discoverable-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NCCpx5+EL2JEWzN6M+a9c643PObQzfEuTHKvkljBmjU=";
  };

  pythonRelaxDeps = [ "ha-mqtt-discoverable" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    gitlike-commands
    ha-mqtt-discoverable
  ];

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [ "ha_mqtt_discoverable_cli" ];

  meta = {
    description = "CLI for creating Home Assistant compatible MQTT entities that will be automatically discovered";
    homepage = "https://github.com/unixorn/ha-mqtt-discoverable-cli";
    changelog = "https://github.com/unixorn/ha-mqtt-discoverable-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hmd";
  };
})
