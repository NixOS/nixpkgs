{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  setuptools,
  python-transip,
}:
buildPythonPackage rec {
  pname = "octodns-transip";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-transip";
    tag = "v${version}";
    hash = "sha256-O9KhHjCdRt5lejwEqpv0OCwIXaqWVc2/u4ghzbYMiBA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    python-transip
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [
    "octodns_transip"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "octoDNS provider that targets Transip DNS";
    homepage = "https://github.com/octodns/octodns-transip";
    changelog = "https://github.com/octodns/octodns-transip/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.provokateurin ];
    teams = [ lib.teams.octodns ];
  };
}
