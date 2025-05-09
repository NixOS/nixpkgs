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
  pname = "octodns-powerdns";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-powerdns";
    tag = "v${version}";
    hash = "sha256-bdCX1oHFZRYr9PvLVbag/La087DMSXZfZ2W0mXffcUY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_powerdns" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "PowerDNS API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-powerdns/";
    changelog = "https://github.com/octodns/octodns-powerdns/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
