{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  ledger,
  hledger,
}:

python3Packages.buildPythonApplication rec {
  pname = "ledger-autosync";
  version = "1.2.0";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/egh/ledger-autosync";
    changelog = "https://github.com/egh/ledger-autosync/releases/tag/v${version}";
    description = "OFX/CSV autosync for ledger and hledger";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eamsden ];
  };
}
