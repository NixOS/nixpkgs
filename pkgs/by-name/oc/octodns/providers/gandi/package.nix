{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-gandi";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-gandi";
    tag = "v${version}";
    hash = "sha256-0wtG/W5pkatLQ0rXTnbHDoycWOUzOK3fcDQzt93opCc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_gandi" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "Gandi v5 API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-gandi";
    changelog = "https://github.com/octodns/octodns-gandi/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.octodns ];
  };
}
