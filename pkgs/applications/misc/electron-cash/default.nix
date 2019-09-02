{ lib, fetchurl, python3Packages, qtbase, makeWrapper }:

let

  python = python3Packages.python;

in

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "3.3.6";

  src = fetchurl {
    url = "https://electroncash.org/downloads/${version}/win-linux/Electron-Cash-${version}.tar.gz";
    # Verified using official SHA-1 and signature from
    # https://github.com/fyookball/keys-n-hashes
    sha256 = "ac435f2bf98b9b50c4bdcc9e3fb2ff19d9c66f8cce5df852f3a4727306bb0a84";
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

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "qdarkstyle<2.6" "qdarkstyle<3"

    substituteInPlace setup.py \
      --replace "(share_dir" "(\"share\""
  '';

  doCheck = false;

  postInstall = ''
    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace "Exec=electron-cash" "Exec=$out/bin/electron-cash"

    # Please remove this when #44047 is fixed
    wrapProgram $out/bin/electron-cash \
      --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-5.${lib.versions.minor qtbase.version}/plugins
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
