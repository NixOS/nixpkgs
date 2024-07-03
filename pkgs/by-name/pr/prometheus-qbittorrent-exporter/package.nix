{ lib
, python3
, fetchPypi
, sourceInfo ? builtins.fromJSON (builtins.readFile ./source-info.json)
}:
python3.pkgs.buildPythonApplication {
  pname = "prometheus-qbittorrent-exporter";
  version = sourceInfo.version;
  pyproject = true;

  src = fetchPypi {
    pname = "prometheus_qbittorrent_exporter";
    inherit (sourceInfo) version;
    hash = "sha256:${sourceInfo.sha256}";
  };

  nativeBuildInputs = [
    python3.pkgs.pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    python-json-logger
    qbittorrent-api
  ];

  pythonImportsCheck = [ "qbittorrent_exporter" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Prometheus exporter for qbittorrent";
    homepage = "https://pypi.org/project/prometheus-qbittorrent-exporter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "prometheus-qbittorrent-exporter";
  };
}
