{
  lib,
  stdenv,
  enableQt ? true,
  fetchFromGitHub,
  python3,
  qtwayland,
  secp256k1,
  grpc-tools,
  wrapQtAppsHook,
  zbar,
}:

let
  version = "4.5.4";

  libsecp256k1_name =
    if stdenv.hostPlatform.isLinux then
      "libsecp256k1.so.{v}"
    else if stdenv.hostPlatform.isDarwin then
      "libsecp256k1.{v}.dylib"
    else
      "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.hostPlatform.isLinux then
      "libzbar.so.0"
    else if stdenv.hostPlatform.isDarwin then
      "libzbar.0.dylib"
    else
      "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-grs";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "electrum-grs";
    rev = "refs/tags/v${version}";
    hash = "sha256-0Bgm84wkrU4r4gwino6pferQwagnJN/ZHJbwNZ5EB8w=";
  };

  pythonRelaxDeps = [ "aiorpcx" ];

  postPatch =
    ''
      # make compatible with protobuf4 by easing dependencies ...
      substituteInPlace ./contrib/requirements/requirements.txt \
        --replace-fail "protobuf>=3.20,<4" "protobuf>=3.20"
      # ... and regenerating the paymentrequest_pb2.py file
      protoc --python_out=. electrum_grs/paymentrequest.proto

      substituteInPlace ./electrum_grs/ecc_fast.py \
        --replace-fail ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
    ''
    + (
      if enableQt then
        ''
          substituteInPlace ./electrum_grs/qrscanner.py \
            --replace-fail ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
        ''
      else
        ''
          sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
        ''
    );

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ grpc-tools ] ++ lib.optionals enableQt [ wrapQtAppsHook ];

  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && enableQt) qtwayland;

  dependencies =
    with python3.pkgs;
    [
      aiohttp
      aiohttp-socks
      aiorpcx
      attrs
      bitstring
      certifi
      cryptography
      dnspython
      groestlcoin-hash
      jsonpatch
      jsonrpclib-pelix
      matplotlib
      pbkdf2
      protobuf
      pysocks
      qrcode
      requests
      # plugins
      bitbox02
      btchip-python
      cbor
      ckcc-protocol
      keepkey
      ledger-bitcoin
      pyserial
      trezor
    ]
    ++ lib.optionals enableQt [
      pyqt6
      qdarkstyle
    ];

  checkInputs =
    with python3.pkgs;
    lib.optionals enableQt [
      pyqt6
    ];

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
