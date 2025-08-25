{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mqtt-exporter";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    tag = "v${version}";
    hash = "sha256-uTs+xIJsLN9re7JppJ+Z7IADoO9Q4HzF/Wf/BF3pZDU=";
  };

  patches = [
    # Allow later prometheus-client, https://github.com/kpetremann/mqtt-exporter/pull/104
    (fetchpatch2 {
      name = "remove-time.patch";
      url = "https://github.com/kpetremann/mqtt-exporter/commit/edc0a274085f01ca095e33e73bcb8400e7fffedb.patch";
      hash = "sha256-aYeqSCf0cvtbTmgrE77RDyafxIcjShjGm7PEndGm/Lo=";
    })
  ];

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
