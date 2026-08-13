{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  ovh,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-ovh";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-ovh";
    tag = "v${version}";
    hash = "sha256-XNwrne+NTriByEmP9JGGWcymDT42lryWtSEcuGdJiXU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    ovh
  ];

  env.OCTODNS_RELEASE = 1;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "octodns_ovh" ];

  meta = {
    description = "OVHcloud DNS v6 API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-ovh";
    changelog = "https://github.com/octodns/octodns-ovh/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
