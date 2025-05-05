{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitLab,
  pyfakefs,
  python-dateutil,
  pythonOlder,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    rev = "refs/tags/v${version}";
    hash = "sha256-taYpSYkfucc9GQpVDiAZgCt/D3Akld20LkFEhsdKH0Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pyfakefs
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cryptodatahub" ];

  preCheck = ''
    # failing tests
    rm test/updaters/test_common.py
    rm test/common/test_key.py
    # Tests require network access
    rm test/common/test_utils.py
  '';

  meta = with lib; {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${version}/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
