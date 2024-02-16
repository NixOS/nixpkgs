{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, ffmpeg
}:

let
  py3Pkgs = python3Packages.override {
    overrides = self: super: {
      # See https://github.com/NixOS/nixpkgs/pull/288219
      paho-mqtt = super.paho-mqtt.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.0";
        pyproject = true;
        format = null;
        disabled = self.pythonOlder "3.7";

        src = fetchFromGitHub {
          owner = "eclipse";
          repo = "paho.mqtt.python";
          rev = "v${version}";
          hash = "sha256-VMq+WTW+njK34QUUTE6fR2j2OmHxVzR0wrC92zYb1rY=";
        };

        build-system = with self; [ hatchling ];

        # Requires an additional package and thus lots more packaging effort
        # than really justified here for this transitional solution.
        doCheck = false;

        meta = oldAttrs.meta // { license = lib.licenses.epl20; };
      });
    };
  };
in
py3Pkgs.buildPythonApplication rec {
  pname = "mqtt-exporter";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    rev = "v${version}";
    hash = "sha256-DjvFm6Om2+iU6/UuLsv/vkssjIB3ZR6Ayz0lfW1Izd4=";
  };

  propagatedBuildInputs = with py3Pkgs; [
    paho-mqtt
    prometheus-client
    setuptools
  ];

  pythonImportsCheck = [ "mqtt_exporter" ];

  meta = with lib; {
    description = "Simple generic MQTT Prometheus exporter for IoT working out of the box";
    homepage = "https://github.com/kpetremann/mqtt-exporter";
    changelog = "https://github.com/kpetremann/mqtt-exporter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ christoph-heiss ];
    mainProgram = "mqtt-exporter";
  };
}
