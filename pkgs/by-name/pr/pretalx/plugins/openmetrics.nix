{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "pretalx-openmetrics";
  version = "unstable-2025-05-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "why2025-datenzone";
    repo = "pretalx-openmetrics";
    rev = "1121a5d430c403bc9aedb7ae8b1aa81219c8a58f";
    hash = "sha256-reQA61JFZsYWE/CAL28Oe60CmGANt0phXLzz9YGtDYQ=";
  };

  build-system = [
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretalx_openmetrics"
  ];

  # no tagged release yet
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "OpenMetrics instrumentation plugin";
    homepage = "https://github.com/why2025-datenzone/pretalx-openmetrics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
