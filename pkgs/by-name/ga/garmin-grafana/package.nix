{
  fetchFromGitHub,
  python3Packages,
  lib,
}:
python3Packages.buildPythonPackage rec {
  pname = "garmin-grafana";
  version = "0.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "arpanghosh8453";
    repo = "garmin-grafana";
    tag = "v${version}";
    hash = "sha256-nuVT6LK9KIs/FwUbdfI4xpKru4jfAyj1/vmk7ji43zk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fitparse
    garminconnect
    influxdb
    influxdb3-python
    python-dotenv
  ];

  doCheck = false; # there are no tests

  dontCheckRuntimeDeps = true;

  postInstall = ''
    install -Dt $out/share/grafana-dashboards -m644 Grafana_Dashboard/Garmin-Grafana-Dashboard.json
  '';

  passthru.grafana-dashboard = "${placeholder "out"}/share/grafana-dashboards/Garmin-Grafana-Dashboard.json";

  meta = {
    description = "Export Garmin data to InfluxDB";
    longDescription = ''
      A Python script to fetch Garmin health data and populate that in an InfluxDB database,
      for visualizing long-term health trends with Grafana
    '';
    homepage = "https://github.com/arpanghosh8453/garmin-grafana";
    changelog = "https://github.com/arpanghosh8453/garmin-grafana/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aciceri ];
    mainProgram = "garmin-fetch";
    platforms = lib.platforms.linux;
  };
}
