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
  version = "1.0.3";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    rev = "v${version}";
    hash = "sha256-IuOlVJEjNqRPfV4q/Zy3UQe5iMwDlnSV356FrTsmflg=";
  };

  patches = [
    (fetchpatch2 {
      name = "drop-distutils.patch";
      url = "https://github.com/egh/ledger-autosync/commit/b7a2a185b9c3b17764322dcc80153410d12e6a5f.patch";
      hash = "sha256-qKuTpsNFuS00yRAH4VGpMA249ml0BGZsGVb75WrBWEo=";
    })
    (fetchpatch2 {
      name = "drop-imp.patch";
      url = "https://github.com/egh/ledger-autosync/commit/453d92ad279e6c90fadf835d1c39189a1179eb17.patch";
      hash = "sha256-mncMvdWldAnVDy1+bJ+oyDOrUb14v9LrBRz/CYrtYbc=";
    })
  ];

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

  # Disable some non-passing tests:
  # https://github.com/egh/ledger-autosync/issues/127
  disabledTests = [
    "test_payee_match"
    "test_args_only"
  ];

  meta = with lib; {
    homepage = "https://github.com/egh/ledger-autosync";
    changelog = "https://github.com/egh/ledger-autosync/releases/tag/v${version}";
    description = "OFX/CSV autosync for ledger and hledger";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eamsden ];
  };
}
