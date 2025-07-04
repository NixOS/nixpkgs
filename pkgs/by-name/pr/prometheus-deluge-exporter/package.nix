{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "deluge-exporter";
  version = "2.4.0-unstable-2024-06-02";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ibizaman";
    repo = "deluge_exporter";
    rev = "8d446c8cba4a324aa052e66c115121b23adc970f";
    hash = "sha256-1brLWx6IEGffcvHPCkz10k9GCNQIXXJ9PYZuEzlKHTA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    deluge-client
    loguru
    prometheus-client
  ];

  pythonImportsCheck = [
    "deluge_exporter"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Deluge";
    homepage = "https://github.com/ibizaman/deluge_exporter";
    license = licenses.isc;
    maintainers = with maintainers; [ ibizaman ];
    mainProgram = "deluge-exporter";
  };
}
