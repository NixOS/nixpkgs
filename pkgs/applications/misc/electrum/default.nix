{ stdenv, fetchurl, python3, python3Packages, zbar }:

let
  qdarkstyle = python3Packages.buildPythonPackage rec {
    pname = "QDarkStyle";
    version = "2.5.4";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1w715m1i5pycfqcpkrggpn0rs9cakx6cm5v8rggcxnf4p0i0kdiy";
    };
    doCheck = false; # no tests
  };
in

python3Packages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "3.2.4";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0nwipn1alk3r54zpsv2bdwsqxw4f08bxnfmygnwakfkiaifmmhxg";
  };

  propagatedBuildInputs = with python3Packages; [
    dnspython
    ecdsa
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf
    pyaes
    pycryptodomex
    pyqt5
    pysocks
    qdarkstyle
    qrcode
    requests
    tlslite-ng
    typing

    # plugins
    keepkey
    trezor
    btchip

    # TODO plugins
    # amodem
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o electrum/gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' electrum/gui/qt/icons_rc.py
    sed -i "s|name = 'libzbar.*'|name='${zbar}/lib/libzbar.so'|" electrum/qrscanner.py
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
