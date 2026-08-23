{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  fetchpatch,
  octodns,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-bind";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-bind";
    tag = "v${version}";
    hash = "sha256-pqcG39iHXjlL5U2InSkg0J7nhQ0TUK8+aYh6UKddSGU=";
  };

  patches = [
    # Fix SRV record validation test
    (fetchpatch {
      name = "octodns-bind-pull-108.patch";
      url = "https://github.com/octodns/octodns-bind/commit/9393bc013d6bfaa1258f34e484f09f5c6306d477.patch";
      hash = "sha256-BHKS5kci265xvoaMZ0fN7bir2I9mpS15muq4fWg7ruk=";
    })
  ];

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
