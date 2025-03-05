{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
, qtwayland
}:

let
  version = "4.5.4";

  libsecp256k1_name =
    if stdenv.hostPlatform.isLinux then "libsecp256k1.so.{v}"
    else if stdenv.hostPlatform.isDarwin then "libsecp256k1.{v}.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.hostPlatform.isLinux then "libzbar.so.0"
    else if stdenv.hostPlatform.isDarwin then "libzbar.0.dylib"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-grs";
  inherit version;

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "electrum-grs";
    rev = "refs/tags/v${version}";
    sha256 = "1k078jg3bw4n3kcxy917m30x1skxm679w8hcw8mlxb94ikrjc66h";
  };

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && enableQt) qtwayland;

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-socks
    aiorpcx
    attrs
    bitstring
    cryptography
    dnspython
    groestlcoin-hash
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf
    pysocks
    qrcode
    requests
    certifi
    jsonpatch
    # plugins
    btchip-python
    ledger-bitcoin
    ckcc-protocol
    keepkey
    trezor
    bitbox02
    cbor
    pyserial
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
  ];

  checkInputs = with python3.pkgs; lib.optionals enableQt [
    pyqt6
  ];

  postPatch = ''
    # make compatible with protobuf4 by easing dependencies ...
    substituteInPlace ./contrib/requirements/requirements.txt \
      --replace "protobuf>=3.20,<4" "protobuf>=3.20"
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

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    mainProgram = "electrum-grs";
  };
}
