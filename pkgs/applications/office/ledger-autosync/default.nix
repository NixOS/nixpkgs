{ lib, python3Packages, fetchFromGitHub, ledger, hledger, useLedger ? true, useHledger ? true }:

python3Packages.buildPythonApplication rec {
  pname = "ledger-autosync";
  version = "unstable-2021-04-01";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    rev = "0b674c57c833f75b1a36d8caf78e1567c8e2180c";
    sha256 = "0q404gr85caib5hg83cnmgx4684l72w9slxyxrwsiwhlf7gm443q";
  };

  patches = [
    # ledger-autosync specifies an URL for its ofxparse
    # dependency. This patch removes the URL to only use the
    # `ofxparse` name. This works because nixpkgs' version of ofxparse
    # is more recent than the latest release.
    ./fix-ofxparse-dependency.patch
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
  checkInputs = with python3Packages; [ ledger hledger nose mock ];
  checkPhase = ''
    nosetests -a generic -a ledger -a hledger
  '';

  meta = with lib; {
    homepage = "https://github.com/egh/ledger-autosync";
    description = "OFX/CSV autosync for ledger and hledger";
    license = licenses.gpl3;
    maintainers = with maintainers; [ eamsden ];
  };
}
