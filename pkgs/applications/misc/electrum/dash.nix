{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "2.9.3.1";
  name = "electrum-dash-${version}";

  src = fetchurl {
    url = "https://github.com/akhavr/electrum-dash/releases/download/${version}/Electrum-DASH-${version}.tar.gz";
    #"https://github.com/dashpay/electrum-dash/releases/download/v${version}/Electrum-DASH-${version}.tar.gz";
    sha256 = "9b7ac205f63fd4bfb15d77a34a4451ef82caecf096f31048a7603bd276dfc33e";
  };

  propagatedBuildInputs = with python2Packages; [
    dnspython
    ecdsa
    pbkdf2
    protobuf
    pyasn1
    pyasn1-modules
    pycrypto
    pyqt4
    qrcode
    requests
    pyaes
    tlslite-ng
    x11_hash
    mnemonic
    jsonrpclib

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
