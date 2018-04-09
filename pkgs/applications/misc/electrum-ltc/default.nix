{ stdenv
, fetchurl
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  name = "electrum-ltc-${version}";
  version = "3.1.2.1";

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "0sdql4k8g3py941rzdskm3k4hkwam4hzvg4qlvs0b5pw139mri86";
  };

  propagatedBuildInputs = with python3Packages; [
    pyaes
    ecdsa
    pbkdf2
    requests
    qrcode
    py_scrypt
    pyqt5
    protobuf
    dnspython
    jsonrpclib-pelix
    pysocks
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ asymmetric ];
  };
}

