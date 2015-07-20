{ stdenv, fetchurl, buildPythonPackage, pythonPackages, slowaes }:

buildPythonPackage rec {
  name = "electrum-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "https://download.electrum.org/Electrum-${version}.tar.gz";
    sha256 = "0idqm77d5rbwpw14wqg4ysvbjyqjw7zlqfcdxniy74i2qwz163bi";
  };

  propagatedBuildInputs = with pythonPackages; [
    dns
    ecdsa
    pbkdf2
    protobuf
    pyasn1
    pyasn1-modules
    pyqt4
    qrcode
    requests
    slowaes
    tlslite
  ];

  preInstall = ''
    mkdir -p $out/share
    sed -i 's@usr_share = .*@usr_share = os.getenv("out")+"/share"@' setup.py
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ emery joachifm ];
  };
}
