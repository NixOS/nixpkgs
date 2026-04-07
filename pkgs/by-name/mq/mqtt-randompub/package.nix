{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "mqtt-randompub";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "mqtt-randompub";
    tag = finalAttrs.version;
    hash = "sha256-6R40dEJSi3i2UxJNXLk+GWA/iykzbGVLFccF8ncymKw=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [ paho-mqtt ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mqtt_randompub" ];

  meta = {
    description = "Tool that sends random MQTT messages to random topics";
    homepage = "https://github.com/fabaff/mqtt-randompub";
    changelog = "https://github.com/fabaff/mqtt-randompub/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqtt-randompub";
  };
})
