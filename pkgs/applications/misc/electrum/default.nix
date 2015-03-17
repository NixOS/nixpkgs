{ stdenv, fetchurl, buildPythonPackage, pythonPackages, slowaes }:

buildPythonPackage rec {
  namePrefix = "";
  name = "electrum-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "https://download.electrum.org/Electrum-${version}.tar.gz";
    sha256 = "1kzrbnkl5jps0kf0420vzpiqjk3v1jxvlrxwhc0f58xbqyc7l4mj";
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

  postPatch = ''
    mkdir -p $out/share
    sed -i 's@usr_share = .*@usr_share = os.getenv("out")+"/share"@' setup.py
  '';

  meta = {
    description = "Bitcoin thin-wallet";
    long-description = "Electrum is an easy to use Bitcoin client. It protects you from losing coins in a backup mistake or computer failure, because your wallet can be recovered from a secret phrase that you can write on paper or learn by heart. There is no waiting time when you start the client, because it does not download the Bitcoin blockchain.";
    homepage = "https://electrum.org";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ "emery@vfemail.net" stdenv.lib.maintainers.joachifm ];
  };
}
