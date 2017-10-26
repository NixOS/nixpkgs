{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "2.9.3";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0d0fzb653g7b8ka3x90nl21md4g3n1fv11czdxpdq3s9yr6js6f2";
  };

  propagatedBuildInputs = with python2Packages; [
    dns
    ecdsa
    jsonrpclib
    matplotlib
    pbkdf2
    protobuf
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

    # TODO plugins
    # amodem
    # btchip
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

    substituteInPlace $out/share/applications/electrum.desktop \
      --replace "Exec=electrum %u" "Exec=$out/bin/electrum %u"
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
    homepage = https://electrum.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry joachifm np ];
  };
}
