{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fix SSHFP fingerprint type and length mismatches
    (fetchpatch {
      name = "octodns-ovh-pull-65.patch";
      url = "https://github.com/octodns/octodns-ovh/commit/8a05d5daa89e2bfaf432a4679bd5c6c6771d348f.patch";
      hash = "sha256-UXLPl1QCdSIjsZlf7jzVFEJ6Y5T1xIx0RI5AmPHrAcA=";
    })
  ];

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
