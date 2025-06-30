{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mqtt-exporter";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    tag = "v${version}";
    hash = "sha256-aEuwJeNMB6sou6oyAwCj11lOdMCjCyEsrDcMF/pHzcg=";
  };

  pythonRelaxDeps = [ "prometheus-client" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    paho-mqtt
    prometheus-client
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mqtt_exporter" ];

  meta = {
    description = "Generic MQTT Prometheus exporter for IoT";
    homepage = "https://github.com/kpetremann/mqtt-exporter";
    changelog = "https://github.com/kpetremann/mqtt-exporter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqtt-exporter";
  };
}
