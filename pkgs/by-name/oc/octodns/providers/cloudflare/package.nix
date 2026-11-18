{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-cloudflare";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-cloudflare";
    tag = "v${version}";
    hash = "sha256-hHSzZtSVonKqbH7xK2Xbn4DvNnxqxyoDtPA3FmCbE/w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_cloudflare" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlags = [
    # Ignore octoDNS deprecation warnings
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "Cloudflare API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-cloudflare/";
    changelog = "https://github.com/octodns/octodns-cloudflare/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ret2pop ];
    teams = [ lib.teams.octodns ];
  };
}
