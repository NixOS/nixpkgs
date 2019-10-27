{ lib, fetchurl, python3Packages, qtbase, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "4.0.10";

  src = fetchurl {
    url = "https://electroncash.org/downloads/${version}/win-linux/Electron-Cash-${version}.tar.gz";
    # Verified using official SHA-1 and signature from
    # https://github.com/fyookball/keys-n-hashes
    sha256 = "48270e12956a2f4ef4d2b0cb60611e47f136b734a3741dab176542a32ae59ee5";
  };

  propagatedBuildInputs = with python3Packages; [
    dnspython
    ecdsa
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    pyaes
    pycrypto
    pyqt5
    pysocks
    qrcode
    requests
    tlslite-ng
    qdarkstyle

    # plugins
    keepkey
    trezor
    btchip
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "qdarkstyle<2.6" "qdarkstyle<3"

    substituteInPlace setup.py \
      --replace "(share_dir" "(\"share\""
  '';

  checkInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    unset HOME
    pytest lib/tests
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace "Exec=electron-cash" "Exec=$out/bin/electron-cash"
  '';

  postFixup = ''
    wrapQtApp $out/bin/electron-cash
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electron-cash help >/dev/null
  '';

  meta = with lib; {
    description = "A Bitcoin Cash SPV Wallet";
    longDescription = ''
      An easy-to-use Bitcoin Cash client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = https://www.electroncash.org/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus nyanloutre ];
    license = licenses.mit;
  };
}
