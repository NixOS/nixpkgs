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
  pname = "octodns-cloudflare";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-cloudflare";
    tag = "v${version}";
    hash = "sha256-8ORqUGmbmKQ1QbGLi3TFF9DCgF/raSpSEFZ62NfNAOQ=";
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

  meta = {
    description = "Cloudflare API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-cloudflare/";
    changelog = "https://github.com/octodns/octodns-cloudflare/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ret2pop ];
    teams = [ lib.teams.octodns ];
  };
}
