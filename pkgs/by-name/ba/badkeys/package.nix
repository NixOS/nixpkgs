{
  lib,
  badkeys,
  fetchFromGitHub,
  python3Packages,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "badkeys";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badkeys";
    repo = "badkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pWbrp+2CBU+dxyXUXT+oSS2fvPjO7qSVHEcoHpXR4JM=";
  };

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
