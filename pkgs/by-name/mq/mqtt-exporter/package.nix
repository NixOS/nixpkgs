{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mqtt-exporter";
  version = "1.4.2";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    rev = "v${version}";
    hash = "sha256-DjvFm6Om2+iU6/UuLsv/vkssjIB3ZR6Ayz0lfW1Izd4=";
  };

  propagatedBuildInputs = with python3Packages; [
    paho-mqtt_2
    prometheus-client
    setuptools
  ];

  pythonImportsCheck = [ "mqtt_exporter" ];

  meta = {
    description = "Simple generic MQTT Prometheus exporter for IoT working out of the box";
    homepage = "https://github.com/kpetremann/mqtt-exporter";
    changelog = "https://github.com/kpetremann/mqtt-exporter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    mainProgram = "mqtt-exporter";
  };
}
