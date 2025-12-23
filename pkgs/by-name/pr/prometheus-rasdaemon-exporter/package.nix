{
  lib,
  python3Packages,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-rasdaemon-exporter";
  version = "0-unstable-2025-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanecz";
    repo = "prometheus-rasdaemon-exporter";
    rev = "06cf02a4fa277fdc422275d9c4fe930786fc3f78";
    hash = "sha256-QPbCwEpbG7gDPOSRcgu82QEqKkmW0uRhmSOWGgwVMDI=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev+g${lib.substring 0 7 src.rev}";

  dependencies = with python3Packages; [
    prometheus-client
  ];

  pythonImportsCheck = [
    "prometheus_rasdaemon_exporter"
  ];

  doCheck = false; # no tests

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Rasdaemon exporter for Prometheus";
    homepage = "https://github.com/sanecz/prometheus-rasdaemon-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "prometheus-rasdaemon-exporter";
  };
}
