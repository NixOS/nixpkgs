{ lib
, fetchurl
, python3Packages
, wrapQtAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "electrum-ltc";
  version = "3.3.8.1";

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "0kxcx1xf6h9z8x0k483d6ykpnmfr30n6z3r6lgqxvbl42pq75li7";
  };

  nativeBuildInputs = with python3Packages; [ pyqt5 wrapQtAppsHook ];

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
    trezor
    btchip
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  checkPhase = ''
    $out/bin/electrum-ltc help >/dev/null
  '';

  meta = with lib; {
    description = "Litecoin thin client";
    longDescription = ''
      Electrum-LTC is a simple, but powerful Litecoin wallet. A twelve-word
      security passphrase (or “seed”) leaves intruders stranded and your peace
      of mind intact. Keep it on paper, or in your head... and never worry
      about losing your litecoins to theft or hardware failure. No waiting, no
      lengthy blockchain downloads and no syncing to the network.
    '';
    homepage = "https://electrum-ltc.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
