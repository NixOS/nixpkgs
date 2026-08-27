{
  lib,
  badkeys,
  fetchFromGitHub,
  python3Packages,
  testers,
  fetchpatch2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "badkeys";
  version = "0.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badkeys";
    repo = "badkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i6wKe3djZL2tHjq3UrC+edU6Gz8EYSXSUry61BaI0v4=";
  };

  patches = [
    # TODO: remove on version > 0.0.19
    (fetchpatch2 {
      name = "Adapt-tests-for-rsainvalid-check-for-latest-Python-c.patch";
      url = "https://github.com/badkeys/badkeys/commit/0bdcc68378bf389aebcc714b8c24de1c8a88a4e9.patch?full_index=1";
      hash = "sha256-K0AsRNxfDQ/qC7abt0rr8tKNP9cfvWJ75DscdyoxF08=";
    })
    (fetchpatch2 {
      name = "Add-test-for-Diffie-Hellman-DH-key.patch";
      url = "https://github.com/badkeys/badkeys/commit/4e16c47dc79dd98865f4e3ec4b981306630a57a3.patch?full_index=1";
      hash = "sha256-6F4lfUOmSkCF4XuiPwnJGD2RrxT5/jsillAyW9vzXMw=";
    })
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    cryptography
    gmpy2
  ];

  optional-dependencies = with python3Packages; [
    dnspython
    paramiko
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "badkeys" ];

  passthru = {
    tests.version = testers.testVersion { package = badkeys; };
  };

  meta = {
    description = "Tool to find common vulnerabilities in cryptographic public keys";
    homepage = "https://badkeys.info/";
    changelog = "https://github.com/badkeys/badkeys/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "badkeys";
  };
})
