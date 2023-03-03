{ lib
, python3Packages
, fetchFromGitHub
, ledger
, hledger
, useLedger ? true
, useHledger ? true
}:

python3Packages.buildPythonApplication rec {
  pname = "ledger-autosync";
  version = "1.0.3";
  format = "pyproject";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    rev = "v${version}";
    sha256 = "0n3y4qxsv1cyvyap95h3rj4bj1sinyfgsajygm7s8di3j5aabqr2";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    asn1crypto
    beautifulsoup4
    cffi
    cryptography
    entrypoints
    fuzzywuzzy
    idna
    jeepney
    keyring
    lxml
    mock
    nose
    ofxclient
    ofxhome
    ofxparse
    pbr
    pycparser
    secretstorage
    six
  ] ++ lib.optional useLedger ledger
    ++ lib.optional useHledger hledger;

  # Checks require ledger as a python package,
  # ledger does not support python3 while ledger-autosync requires it.
  nativeCheckInputs = with python3Packages; [ ledger hledger nose mock pytestCheckHook ];

  # Disable some non-passing tests:
  # https://github.com/egh/ledger-autosync/issues/127
  disabledTests = [
    "test_payee_match"
    "test_args_only"
  ];

  meta = with lib; {
    homepage = "https://github.com/egh/ledger-autosync";
    description = "OFX/CSV autosync for ledger and hledger";
    license = licenses.gpl3;
    maintainers = with maintainers; [ eamsden ];
  };
}
