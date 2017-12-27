{ stdenv
, fetchurl
, python2Packages
}:

python2Packages.buildPythonApplication rec {
  name = "electrum-ltc-${version}";
  version = "2.9.3.1";

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "d931a5376b7f38fba7221b01b1010f172c4d662668adae5c38885a646d5ee530";
  };

  propagatedBuildInputs = with python2Packages; [
    pyqt4
    ecdsa
    pbkdf2
    requests
    qrcode
    ltc_scrypt
    protobuf3_2
    dns
    jsonrpclib
    pyaes
    pysocks
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

