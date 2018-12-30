{ stdenv, fetchurl, python3Packages, qtbase, makeWrapper, lib }:

let

  python = python3Packages.python;

in

python3Packages.buildPythonApplication rec {
  version = "3.3.2";
  name = "electron-cash-${version}";

  src = fetchurl {
    url = "https://electroncash.org/downloads/${version}/win-linux/ElectronCash-${version}.tar.gz";
    # Verified using official SHA-1 and signature from
    # https://github.com/fyookball/keys-n-hashes
    sha256 = "4538044cfaa4f87a847635849e0733f32b183ac79abbd2797689c86dc3cb0d53";
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

    # plugins
    keepkey
    trezor
    btchip
  ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # Remove pyqt5 check
    sed -i '/pyqt5/d' setup.py
  '';

  preBuild = ''
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  doCheck = false;

  postInstall = ''
    # These files are installed under $out/homeless-shelter ...
    mv $out/${python.sitePackages}/homeless-shelter/.local/share $out
    rm -rf $out/${python.sitePackages}/homeless-shelter

    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace "Exec=electron-cash %u" "Exec=$out/bin/electron-cash %u"

    # Please remove this when #44047 is fixed
    wrapProgram $out/bin/electron-cash \
      --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-5.${lib.versions.minor qtbase.version}/plugins
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electron-cash help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "A lightweight Bitcoin wallet";
    longDescription = ''
      An easy-to-use Bitcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = https://www.electroncash.org/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus ];
    license = licenses.mit;
  };
}
