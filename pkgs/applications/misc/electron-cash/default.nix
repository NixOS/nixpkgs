{ stdenv, fetchurl, python3Packages, qtbase }:

let

  python = python3Packages.python;

in

python3Packages.buildPythonApplication rec {
  version = "3.1.6";
  name = "electron-cash-${version}";

  src = fetchurl {
    url = "https://electroncash.org/downloads/${version}/win-linux/ElectronCash-${version}.tar.gz";
    # Verified using official SHA-1 and signature from
    # https://github.com/fyookball/keys-n-hashes
    sha256 = "062k5iw0jcp10zxrffvgiyfg51c5xzs7gmm638icx01yy67d58dm";
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
    tlslite

    # plugins
    keepkey
    trezor
  ];

  postPatch = ''
    # Remove pyqt5 check
    sed -i '/pyqt5/d' setup.py
  '';

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  doCheck = false;

  postInstall = ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python.sitePackages}/nix

    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace "Exec=electron-cash %u" "Exec=$out/bin/electron-cash %u"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electrum help >/dev/null
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
