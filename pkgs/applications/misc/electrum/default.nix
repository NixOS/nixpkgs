{ stdenv, fetchurl, pythonPackages }:

let
  jsonrpclib = pythonPackages.buildPythonPackage rec {
    version = "0.1.7";
    name = "jsonrpclib-${version}";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonrpclib/${name}.tar.gz";
      sha256 = "02vgirw2bcgvpcxhv5hf3yvvb4h5wzd1lpjx8na5psdmaffj6l3z";
    };
    propagatedBuildInputs = [ pythonPackages.cjson ];
    meta = {
      homepage = https://pypi.python.org/pypi/jsonrpclib;
      license = stdenv.lib.licenses.asl20;
    };
  };
in

pythonPackages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "2.6.3";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0lj3a8zg6dznpnnxyza8a05c13py52j62rqlad1zcgksm5g63vic";
  };

  propagatedBuildInputs = with pythonPackages; [
    dns
    ecdsa
    jsonrpclib
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
