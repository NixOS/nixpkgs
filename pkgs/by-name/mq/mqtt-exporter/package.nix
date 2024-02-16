{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "mqtt-exporter";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kpetremann";
    repo = "mqtt-exporter";
    rev = "v${version}";
    hash = "sha256-Pjs8PlB1Hogkr54pbXRl8NSdfVoKvFoQNoVt4rMtsts=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kpetremann/mqtt-exporter/commit/c3bdb1454819a936a3b6f246e241bb9f1efc1db7.patch";
      hash = "sha256-cYYoZ39fqOhM90sbf+PAuKVWcgDAgwC2SkFJhVofxic=";
    })
    (fetchpatch {
      url = "https://github.com/kpetremann/mqtt-exporter/commit/d3deaea2ae8e8761c7bf0ee8237c0360b2ea5082.patch";
      hash = "sha256-FKP+K+vExZwrCiBdg1IsZbl4QwxGYRbxXBYYv2km+DU=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
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
    mainProgram = pname;
  };
}
