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
  pname = "octodns-hetzner";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-hetzner";
    tag = "v${version}";
    hash = "sha256-JYVztSO38y4F+p0glgtT9/QRdt9uDnOziMFXxBikzLg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_hetzner" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "Hetzner DNS provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-hetzner/";
    changelog = "https://github.com/octodns/octodns-hetzner/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
