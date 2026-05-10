{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  setuptools,
  requests,
}:
buildPythonPackage rec {
  pname = "octodns-ddns";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-ddns";
    tag = "v${version}";
    hash = "sha256-aIXRlQeh8GpbqxvgTSngFGpQt01K61Z7sVdAgIs7bkM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [
    "octodns_ddns"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Simple Dynamic DNS source for octoDNS";
    homepage = "https://github.com/octodns/octodns-ddns";
    changelog = "https://github.com/octodns/octodns-ddns/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.provokateurin ];
    teams = [ lib.teams.octodns ];
  };
}
