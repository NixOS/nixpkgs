{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "2.7.9";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0a3bdfcyrq5g3ihck80fqxxyzpj5k9sfax2nsmmwafmzmfqw819h";
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
