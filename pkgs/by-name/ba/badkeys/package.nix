{
  lib,
  badkeys,
  fetchFromGitHub,
  python3Packages,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "badkeys";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badkeys";
    repo = "badkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cefoHPajW9sZXsGCehk4pW4J32AASCxYnaAVOi9q4Yw=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with python3Packages;
    [
      cryptography
      gmpy2
    ]
    ++ lib.concatAttrValues (finalAttrs.passthru.optional-dependencies);

  optional-dependencies = with python3Packages; {
    ssh = [ paramiko ];
    dkim = [ dnspython ];
  };

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
