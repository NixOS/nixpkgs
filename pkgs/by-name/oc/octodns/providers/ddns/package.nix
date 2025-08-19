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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-ddns";
    tag = "v${version}";
    hash = "sha256-n4dTkJT5UmmEqtN5x2zkJe7NQtjXz3gPwwFnOmMIfIs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  postPatch = ''
    substituteInPlace tests/test_octodns_source_ddns.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

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
