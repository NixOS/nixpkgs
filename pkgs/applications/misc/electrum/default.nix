{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "2.6.4";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0rpqpspmrmgm0bhsnlnhlwhag6zg8hnv5bcw5vkqmv86891kpd9a";
  };

  propagatedBuildInputs = with pythonPackages; [
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

  preInstall = ''
    mkdir -p $out/share
    sed -i 's@usr_share = .*@usr_share = os.getenv("out")+"/share"@' setup.py
    pyrcc4 icons.qrc -o gui/qt/icons_rc.py
  '';

  doCheck = true;
  checkPhase = ''
    $out/bin/electrum help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "Bitcoin thin-client";
    longDescription = ''
      An easy-to-use Bitcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = https://electrum.org;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry joachifm np ];
  };
}
