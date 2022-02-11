{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
}:

let
  version = "4.1.5";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

  py = python3.override {
    packageOverrides = self: super: {

      aiorpcx = super.aiorpcx.overridePythonAttrs (oldAttrs: rec {
        version = "0.18.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1rswrspv27x33xa5bnhrkjqzhv0sknv5kd7pl1vidw9d2z4rx2l0";
        };
      });
    };
  };

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-grs";
  inherit version;

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "electrum-grs";
    rev = "v${version}";
    sha256 = "0wvbjj80r1zxpz24adkicxsdjnv3nciga6rl1wfmky463w03rca2";
  };

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "dnspython>=2.0,<2.1" "dnspython>=2.0"
  '';

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs = with py.pkgs; [
    aiohttp
    aiohttp-socks
    aiorpcx
    attrs
    bitstring
    cryptography
    dnspython
    groestlcoin_hash
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf
    pysocks
    qrcode
    requests
    tlslite-ng
    # plugins
    btchip
    ckcc-protocol
    keepkey
    trezor
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    substituteInPlace ./electrum_grs/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum_grs/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    # Despite setting usr_share above, these files are installed under $out/nix ...
    mv $out/${python3.sitePackages}/nix/store/*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum-grs.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-grs %u"' \
                "Exec=$out/bin/electrum-grs %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-grs --testnet %u"' \
                "Exec=$out/bin/electrum-grs --testnet %u"

  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-grs
  '';

  postCheck = ''
    $out/bin/electrum-grs help >/dev/null
  '';

  meta = with lib; {
    description = "Lightweight Groestlcoin wallet";
    longDescription = ''
      An easy-to-use Groestlcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://groestlcoin.org/";
    downloadPage = "https://github.com/Groestlcoin/electrum-grs/releases/tag/v{version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ gruve-p ];
  };
}
