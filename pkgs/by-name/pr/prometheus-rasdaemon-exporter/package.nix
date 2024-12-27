{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "prometheus-rasdaemon-exporter";
  version = "unstable-2023-03-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanecz";
    repo = "prometheus-rasdaemon-exporter";
    rev = "e37084edeb4d397dd360298cb22f18f83a35ff46";
    hash = "sha256-O0Zzog+5jDixFRGbqmjPYi6JDpHbxpU4hKfsqTnexS8=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev9+ge37084e";

  dependencies = with python3Packages; [
    prometheus-client
  ];

  pythonImportsCheck = [
    "prometheus_rasdaemon_exporter"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Rasdaemon exporter for Prometheus";
    homepage = "https://github.com/sanecz/prometheus-rasdaemon-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "prometheus-rasdaemon-exporter";
  };
}
