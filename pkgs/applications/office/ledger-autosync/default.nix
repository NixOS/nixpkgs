{ stdenv, python3Packages, fetchFromGitHub, ledger, hledger, useLedger ? true, useHledger ? true }:

python3Packages.buildPythonApplication rec {
  pname = "ledger-autosync";
  version = "1.0.1";

# no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "egh";
    repo = "ledger-autosync";
    rev = "v${version}";
    sha256 = "1h5mjngdd3rmzwmy026xmas0491kxxi1vxkd5m1xii7y6j50z14q";
  };

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
  ] ++ stdenv.lib.optional useLedger ledger
    ++ stdenv.lib.optional useHledger hledger;

  # Checks require ledger as a python package,
  # ledger does not support python3 while ledger-autosync requires it.
  checkInputs = with python3Packages; [ ledger hledger nose mock ];
  checkPhase = ''
    nosetests -a generic -a ledger -a hledger
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/egh/ledger-autosync;
    description = "OFX/CSV autosync for ledger and hledger";
    license = licenses.gpl3;
    maintainers = with maintainers; [ eamsden ];
  };
}
