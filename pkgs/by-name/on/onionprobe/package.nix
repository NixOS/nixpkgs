{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "onionprobe";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rjExMm1mkoeRiv+aNuC6Ieo0/X5sbsjuSiAHcnQxjFo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    stem
    prometheus-client
    pyyaml
    pysocks
    cryptography
  ];

  meta = {
    description = "Tooling for onion service monitoring";
    homepage = "https://onionservices.torproject.org/apps/web/onionprobe/";
    changelog = "https://gitlab.torproject.org/tpo/onion-services/onionprobe/-/blob/${version}/docs/changelog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.ForgottenBeast ];
    mainProgram = "onionprobe";
  };
}
