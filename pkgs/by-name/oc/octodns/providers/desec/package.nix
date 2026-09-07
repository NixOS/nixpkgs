{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-desec";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rootshell-labs";
    repo = "octodns-desec";
    tag = version;
    hash = "sha256-tRviqrNkKYWj4a3EWCJEco8AnzFuRkvSCzZ1HrSye/I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_desec" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "deSEC DNS provider for octoDNS";
    homepage = "https://github.com/rootshell-labs/octodns-desec";
    changelog = "https://github.com/rootshell-labs/octodns-desec/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
