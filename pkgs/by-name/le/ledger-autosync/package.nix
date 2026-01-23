{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  ledger,
  hledger,
}:

python3Packages.buildPythonApplication rec {
  pname = "ledger-autosync";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    tag = "v${version}";
    hash = "sha256-bbFjDdxYr85OPjdvY3JYtCe/8Epwi+8JN60PKVKbqe0=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    ofxclient
    ofxparse
  ];

  nativeCheckInputs = [
    hledger
    ledger
    python3Packages.ledger
    python3Packages.pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # keyring.errors.KeyringError: Can't get password from keychain: (-50, 'Unknown Error')
    # keyring.backends.macOS.api.Error: (-50, 'Unknown Error')
    "tests/test_cli.py"
    "tests/test_weird_ofx.py"
  ];

  meta = {
    homepage = "https://github.com/egh/ledger-autosync";
    changelog = "https://github.com/egh/ledger-autosync/releases/tag/v${version}";
    description = "OFX/CSV autosync for ledger and hledger";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eamsden ];
  };
}
