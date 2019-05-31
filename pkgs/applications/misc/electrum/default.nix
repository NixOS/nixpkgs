{ stdenv, fetchurl, fetchFromGitHub, python3, python3Packages, zbar, secp256k1


# for updater.nix
, writeScript
, common-updater-scripts
, bash
, coreutils
, curl
, gnugrep
, gnupg
, gnused
, nix
}:

let
  version = "3.3.6";

  # Not provided in official source releases, which are what upstream signs.
  tests = fetchFromGitHub {
    owner = "spesmilo";
    repo = "electrum";
    rev = version;
    sha256 = "0s8i6fn1jwk80d036n4c7csv4qnx2k15f6347kr4mllglcpa9hb3";

    extraPostFetch = ''
      mv $out ./all
      mv ./all/electrum/tests $out
    '';
  };
in

python3Packages.buildPythonApplication rec {
  pname = "electrum";
  inherit version;

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "0am5ki3z0yvhrz16vp2jjy5fkxxqph0mj9qqpbw3kpql65shykwz";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/electrum/tests
  '';

  propagatedBuildInputs = with python3Packages; [
    aiorpcx
    aiohttp
    aiohttp-socks
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

    # plugins
    keepkey
    trezor
    btchip

    # TODO plugins
    # amodem
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    sed -i "s|name = 'libzbar.*'|name='${zbar}/lib/libzbar.so'|" electrum/qrscanner.py
    substituteInPlace ./electrum/ecc_fast.py --replace libsecp256k1.so.0 ${secp256k1}/lib/libsecp256k1.so.0
  '';

  postInstall = ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python3.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum %u"' \
                "Exec=$out/bin/electrum %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum --testnet %u"' \
                "Exec=$out/bin/electrum --testnet %u"
  '';

  checkInputs = with python3Packages; [ pytest ];

  checkPhase = ''
    py.test electrum/tests
    $out/bin/electrum help >/dev/null
  '';

  passthru.updateScript = import ./update.nix {
    inherit (stdenv) lib;
    inherit
      writeScript
      common-updater-scripts
      bash
      coreutils
      curl
      gnupg
      gnugrep
      gnused
      nix
    ;
  };

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
