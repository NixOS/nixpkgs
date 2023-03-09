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
  version = "4.3.1";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else if stdenv.isDarwin then "libzbar.0.dylib"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-grs";
  inherit version;

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "electrum-grs";
    rev = "refs/tags/v${version}";
    sha256 = "1h9r32wdn0p7br36r719x96c8gay83dijw80y2ks951mam16mkkb";
  };

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
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

  postPatch = ''
    # make compatible with protobuf4 by easing dependencies ...
    substituteInPlace ./contrib/requirements/requirements.txt \
      --replace "protobuf>=3.12,<4" "protobuf>=3.12"
    # ... and regenerating the paymentrequest_pb2.py file
    protoc --python_out=. electrum_grs/paymentrequest.proto

    substituteInPlace ./electrum_grs/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum_grs/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/share/applications/electrum-grs.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-grs %u"' \
                "Exec=$out/bin/electrum-grs %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-grs --testnet %u"' \
                "Exec=$out/bin/electrum-grs --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-grs
  '';

  # the tests are currently broken
  doCheck = false;

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
