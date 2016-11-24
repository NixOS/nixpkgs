{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "2.7.11";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0qy2ynyw57jgi7fw3xzsyy608yk4bhsda7qfw0j26zqinv52mrsb";
  };

  propagatedBuildInputs = with python2Packages; [
    dns
    ecdsa
    jsonrpclib
    pbkdf2
    protobuf3_0
    pyasn1
    pyasn1-modules
    pycrypto
    pyqt4
    qrcode
    requests
    slowaes
    tlslite

    # plugins
    trezor
    keepkey
    # TODO plugins
    # matplotlib
    # btchip
    # amodem
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc4 icons.qrc -o gui/qt/icons_rc.py
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electrum help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "A lightweight Bitcoin wallet";
    longDescription = ''
      An easy-to-use Bitcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = https://electrum.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry joachifm np ];
  };
}
