{ stdenv
, fetchurl
, python2Packages
}:

python2Packages.buildPythonApplication rec {
  name = "electrum-ltc-${version}";
  version = "2.6.4.2";

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "0sqcyk6n6kgaiinnwh6mzbbn4whk3ga59r5bw5rqmnnfqk1xdnb4";
  };

  propagatedBuildInputs = with python2Packages; [
    pyqt4
    slowaes
    ecdsa
    pbkdf2
    requests
    qrcode
    ltc_scrypt
    protobuf3_2
    dns
    jsonrpclib
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc4 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  checkPhase = ''
    $out/bin/electrum-ltc help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "Litecoin thin client";
    longDescription = ''
      Electrum-LTC is a simple, but powerful Litecoin wallet. A twelve-word
      security passphrase (or “seed”) leaves intruders stranded and your peace
      of mind intact. Keep it on paper, or in your head... and never worry
      about losing your litecoins to theft or hardware failure. No waiting, no
      lengthy blockchain downloads and no syncing to the network.
    '';
    homepage = https://electrum-ltc.org/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ asymmetric ];
  };
}

