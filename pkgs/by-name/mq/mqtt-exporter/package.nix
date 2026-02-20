{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "mqtt-exporter";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z2y43sRlwgy3Bwhu8rvlTkf6HOT+v8kjo5FT3lo5CEA=";
  };

  patches = [
    (fetchpatch {
      name = "Fix `mqtt-exporter` script";
      url = "https://github.com/kpetremann/mqtt-exporter/commit/53f5f31b28cb5aeec1c8d0bb7d1aea56f036082e.diff";
      hash = "sha256-LS+kO6bHofNQxk9o+ExsJnaecwfY/40S0MIJwpJxCAI=";
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
    changelog = "https://github.com/kpetremann/mqtt-exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqtt-exporter";
  };
})
