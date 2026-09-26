{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  octodns,
  pytestCheckHook,
  setuptools,
  python-transip,
}:
buildPythonPackage rec {
  pname = "octodns-transip";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-transip";
    tag = "v${version}";
    hash = "sha256-O9KhHjCdRt5lejwEqpv0OCwIXaqWVc2/u4ghzbYMiBA=";
  };

  patches = [
    # Update hex comparison to be case insensitive in tests
    (fetchpatch {
      name = "octodns-transip-pull-71.patch";
      url = "https://github.com/octodns/octodns-transip/commit/100fe61c5ff20a8fce319a48bfc7bbfddc995a48.patch";
      hash = "sha256-RfLAZSDVjLKUw/2g25vSySGrJdlb0I+HfBZE6hLtc6Q=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    python-transip
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [
    "octodns_transip"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    # Ignore octoDNS 2.0 deprecation warnings
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "octoDNS provider that targets Transip DNS";
    homepage = "https://github.com/octodns/octodns-transip";
    changelog = "https://github.com/octodns/octodns-transip/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.provokateurin ];
    teams = [ lib.teams.octodns ];
  };
}
