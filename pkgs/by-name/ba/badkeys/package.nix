{
  lib,
  badkeys,
  fetchFromGitHub,
  python3Packages,
  testers,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "badkeys";
  version = "0.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badkeys";
    repo = "badkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ylGPxumqROB1GyXhZYi4ow6qqcsvaZFMWb9+c4JaCNs=";
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
      pyopenssl
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool to find common vulnerabilities in cryptographic public keys";
    homepage = "https://badkeys.info/";
    changelog = "https://github.com/badkeys/badkeys/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "badkeys";
  };
})
