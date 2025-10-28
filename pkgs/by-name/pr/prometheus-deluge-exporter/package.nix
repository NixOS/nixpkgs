{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  version = "2.4.1";
in
python3.pkgs.buildPythonApplication {
  pname = "deluge-exporter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ibizaman";
    repo = "deluge_exporter";
    tag = "v${version}";
    hash = "sha256-1brLWx6IEGffcvHPCkz10k9GCNQIXXJ9PYZuEzlKHTA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
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
