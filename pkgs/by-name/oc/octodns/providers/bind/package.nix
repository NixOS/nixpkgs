{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  pythonOlder,
  dnspython,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-bind";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-bind";
    tag = "v${version}";
    hash = "sha256-ezLaNeqJoi3fcfwQFkiEyYUSlw7cTCikmv0qmPTzrvI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    dnspython
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_bind" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "RFC compliant (Bind9) provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-bind";
    changelog = "https://github.com/octodns/octodns-bind/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
