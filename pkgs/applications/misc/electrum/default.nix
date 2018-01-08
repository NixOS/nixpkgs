{ stdenv, fetchurl, python3, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "3.0.5";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "06z0a5p1jg93jialphslip8d72q9yg3651qqaf494gs3h9kw1sv1";
  };

  propagatedBuildInputs = with python3Packages; [
    dns
    ecdsa
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf3_2
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

    # TODO plugins
    # amodem
    # btchip
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  postInstall = ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python3.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum.desktop \
      --replace "Exec=electrum %u" "Exec=$out/bin/electrum %u"
  '';

  doCheck = false;

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
