{
  lib,
  python313Packages,
  fetchPypi,
}:

python313Packages.buildPythonPackage rec {
  pname = "onionprobe";
  version = "1.4.0";

  format = "wheel";
  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-3MiumgSVZaEqcJOSKVo0yDqvmzWjir0m4UMn7w6zouk=";
    python = "py3";
    dist = "py3";
  };

  propagatedBuildInputs = with python313Packages; [
    setuptools
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
    licence = lib.licences.gpl3Plus;
    maintainers = lib.maintainers.ForgottenBeast;
    mainProgram = "onionprobe";
  };
}
