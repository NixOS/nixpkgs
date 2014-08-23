{ stdenv, fetchurl, pythonPackages, slowaes, ecdsa, pyqt4 }:

pythonPackages.buildPythonPackage rec {
  name = "electrum-${version}";
  version = "1.9.8";

  src = fetchurl {
    url = "https://download.electrum.org/Electrum-${version}.tar.gz";
    sha256 = "8fc144a32013e4a747fea27fff981762a6b9e14cde9ffb405c4c721975d846ff";
  };

  buildInputs = [ slowaes ecdsa ];

  propagatedBuildInputs = [ 
    slowaes
    ecdsa
    pyqt4
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
    maintainers = [ "emery@vfemail.net" ];
  };
}