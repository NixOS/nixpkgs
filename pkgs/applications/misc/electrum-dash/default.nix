{ stdenv, fetchurl, buildPythonApplication, pythonPackages, slowaes }:

buildPythonApplication rec {
  name = "electrum-dash-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/dashpay/electrum-dash/releases/download/v${version}/Electrum-DASH-${version}.tar.gz";
    sha256 = "02k7m7fyn0cvlgmwxr2gag7rf2knllkch1ma58shysp7zx9jb000";
  };

  propagatedBuildInputs = with pythonPackages; [
    dns
    ecdsa
    pbkdf2
    protobuf
    pyasn1
    pyasn1-modules
    pycrypto
    pyqt4
    qrcode
    requests
    slowaes
    tlslite
    x11_hash
    mnemonic

    # plugins
    trezor
  ];

  preInstall = ''
    mkdir -p $out/share
    sed -i 's@usr_share = .*@usr_share = os.getenv("out")+"/share"@' setup.py
    pyrcc4 icons.qrc -o gui/qt/icons_rc.py
  '';

  meta = with stdenv.lib; {
    description = "Electrum DASH";
    homepage = https://github.com/dashpay/electrum-dash;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
