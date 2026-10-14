{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hcloud,
  octodns,
  pytestCheckHook,
  requests-mock,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-hetzner";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-hetzner";
    tag = "v${version}";
    hash = "sha256-aWWT/LShHxWOfNhBr7vCeG9bA6yXEutO2NJic18szL8=";
  };

  patches = [
    # Update hex comparison to be case insensitive in tests
    (fetchpatch {
      name = "octodns-hetzner-pull-66.patch";
      url = "https://github.com/octodns/octodns-hetzner/commit/d8f7c6c31b13da4c507dd0d3761a1935bf0524e6.patch";
      hash = "sha256-SPfxVOQOM0I4cRX9WZNCOqM+om6PgosV3/LUOMSw8t4=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
    hcloud
  ];

  pythonImportsCheck = [ "octodns_hetzner" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlags = [
    # Ignore octoDNS 2.0 deprecation warnings
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "Hetzner DNS provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-hetzner/";
    changelog = "https://github.com/octodns/octodns-hetzner/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.octodns ];
  };
}
