{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "badkeys";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badkeys";
    repo = "badkeys";
    rev = "refs/tags/v${version}";
    hash = "sha256-LFoB/ZHIMRpN/eHg3x8HCxNbMKclf2SJSDPk33OIil8=";
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

  meta = {
    description = "Tool to find common vulnerabilities in cryptographic public keys";
    homepage = "https://badkeys.info/";
    changelog = "https://github.com/badkeys/badkeys/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "badkeys";
  };
}
