{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  name = "keeper-security-commander";
  pname = "commander";
  version = "17.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Keeper-Security";
    repo = "Commander";
    rev = "v${version}";
    hash = "sha256-NIPKwWvUBkaM8eMW7J56viZoYSHRkxB0WF3DlCS7TAA=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    asciitree
    bcrypt
    colorama
    cryptography
    fido2
    flask
    flask-limiter
    fpdf2
    keeper-pam-webrtc-rs
    keeper-secrets-manager-core
    prompt-toolkit
    protobuf
    psutil
    pycryptodomex
    pydantic
    pyngrok
    pyperclip
    python-dotenv
    requests
    tabulate
    websockets
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "tests/test_enterprise_commands.py" # No such file or directory: '/build/source/tests/enterprise.json'
    "tests/test_vault_commands.py" # No such file or directory: '/build/source/tests/vault.json'
  ];
  doCheck = true;

  meta = {
    description = "Keeper Commander is a python-based CLI and SDK interface to the Keeper Security platform. Provides administrative controls, reporting, import/export and vault management.";
    homepage = "https://github.com/Keeper-Security/Commander";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gesperon ];
    mainProgram = "keeper";
  };
}
