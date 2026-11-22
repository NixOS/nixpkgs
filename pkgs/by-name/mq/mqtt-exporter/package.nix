{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mqtt-exporter";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cCVbvO1+69zIxbGGW7p3YTbDQgSU41uVR7M3jOHaqO8=";
  };

  patches = [
    # https://github.com/kpetremann/mqtt-exporter/pull/135
    # Updates the paho-mqtt dependency to the latest version (which matches the
    # version in nixpkgs).
    (fetchpatch2 {
      url = "https://github.com/kpetremann/mqtt-exporter/commit/3b92d1b1bc20c468dbfa7522987acd1216a9fc62.patch";
      hash = "sha256-hNCiSXPfHmDbtBuPXs0BjB8mztRIdBVJbj1Yz28Khm8=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    paho-mqtt
    prometheus-client
  ];

  pythonRelaxDeps = [ "prometheus-client" ];

  nativeCheckInputs = with python3Packages; [
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
