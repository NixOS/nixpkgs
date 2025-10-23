{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
}:

python3Packages.buildPythonApplication {
  pname = "prometheus-rasdaemon-exporter";
  version = "0-unstable-2023-03-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanecz";
    repo = "prometheus-rasdaemon-exporter";
    rev = "e37084edeb4d397dd360298cb22f18f83a35ff46";
    hash = "sha256-O0Zzog+5jDixFRGbqmjPYi6JDpHbxpU4hKfsqTnexS8=";
  };

  patches = [
    # Normalization of metric names
    # https://github.com/sanecz/prometheus-rasdaemon-exporter/pull/1
    (fetchpatch2 {
      url = "https://github.com/sanecz/prometheus-rasdaemon-exporter/commit/46d379ba205c2340a0b266bf3cd48ec88ce025d0.patch";
      hash = "sha256-kqo1Tjn51M1FzArS4K0ylQ2/rFDOAiZU3OUt/oBhGhM=";
    })
    (fetchpatch2 {
      url = "https://github.com/sanecz/prometheus-rasdaemon-exporter/commit/c9ab08e8918497edb8f1ab0f933fa270cb7860a8.patch";
      hash = "sha256-QtjzXuxPG7e+cgUDVbAVNY4VyBp3W5+vQDAvFJ9t92I=";
    })
    # Fix sqlite3.connect URI passing
    # https://github.com/sanecz/prometheus-rasdaemon-exporter/pull/2
    (fetchpatch2 {
      url = "https://github.com/sanecz/prometheus-rasdaemon-exporter/commit/52f6c47b77f480cd7f83853a2baffffb45f77b37.patch";
      hash = "sha256-XYeWMkAhWJIOUKLeTstIJr3P37Jwt8tzRURCvlrrxVs=";
    })
  ];

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
