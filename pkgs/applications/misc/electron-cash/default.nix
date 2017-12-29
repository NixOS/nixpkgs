{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "2.9.4";
  name = "electron-cash-${version}";

  src = fetchurl {
    url = "https://electroncash.org/downloads/${version}/win-linux/Electron-Cash-${version}.tar.gz";
    # Verified using official SHA-1 and signature from
    # https://github.com/fyookball/keys-n-hashes
    sha256 = "1y8mzwa6bb8zj4l92wm4c2icnr42wmhbfz6z5ymh356gwll914vh";
  };

  propagatedBuildInputs = with python2Packages; [
    dns
    ecdsa
    jsonrpclib
    pbkdf2
    pyaes
    pycrypto
    pyqt4
    pysocks
    qrcode
    requests
    tlslite

    # plugins
    keepkey
    trezor
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc4 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  postInstall = ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/lib/python2.7/site-packages/nix/store"/"*/share $out
    rm -rf $out/lib/python2.7/site-packages/nix

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
    maintainers = with maintainers; [ lassulus ];
    license = licenses.mit;
  };
}
