{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mqtt-randompub";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "mqtt-randompub";
    rev = "refs/tags/${version}";
    hash = "sha256-vAFEVlw9reRP+4Qwywv+cP27SU1c3seL3Z+b/YfUdl8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ paho-mqtt ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mqtt_randompub" ];

  meta = {
    description = "Tool that sends random MQTT messages to random topics";
    homepage = "https://github.com/fabaff/mqtt-randompub";
    changelog = "https://github.com/fabaff/mqtt-randompub/blob/${src.rev}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqtt-randompub";
  };
}
