{
  lib,
  stdenv,
  fetchurl,
  protobuf,
  wrapQtAppsHook,
  python3,
  zbar,
  secp256k1,
  enableQt ? true,
  callPackage,
  qtwayland,
}:

let
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

python3.pkgs.buildPythonApplication rec {
  pname = "electrum";
  version = "4.5.8";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    hash = "sha256-3YWVoTgTLe6Hzuds52Ch1iL8L9ZdO2rH335Tt/tup+g=";
  };

  build-system = [ protobuf ] ++ lib.optionals enableQt [ wrapQtAppsHook ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && enableQt) qtwayland;

  dependencies =
    with python3.pkgs;
    [
      aiohttp
      aiohttp-socks
      aiorpcx
      attrs
      bitstring
      cryptography
      dnspython
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
      cbor2
      pyserial
    ]
    ++ lib.optionals enableQt [
      pyqt5
      qdarkstyle
    ];

  checkInputs =
    with python3.pkgs;
    lib.optionals enableQt [
      pyqt6
    ];

  postPatch =
    ''
      # make compatible with protobuf4 by easing dependencies ...
      substituteInPlace ./contrib/requirements/requirements.txt \
        --replace "protobuf>=3.20,<4" "protobuf>=3.20"
      # ... and regenerating the paymentrequest_pb2.py file
      protoc --python_out=. electrum/paymentrequest.proto

      substituteInPlace ./electrum/ecc_fast.py \
        --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
    ''
    + (
      if enableQt then
        ''
          substituteInPlace ./electrum/qrscanner.py \
            --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
        ''
      else
        ''
          sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
        ''
    );

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/applications/electrum.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum %u"' \
                "Exec=$out/bin/electrum %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum --testnet %u"' \
                "Exec=$out/bin/electrum --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pyaes
    pycryptodomex
  ];

  pytestFlagsArray = [ "tests" ];

  postCheck = ''
    $out/bin/electrum help >/dev/null
  '';

  passthru.updateScript = callPackage ./update.nix { };

  meta = with lib; {
    description = "Lightweight Bitcoin wallet";
    longDescription = ''
      An easy-to-use Bitcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://electrum.org/";
    downloadPage = "https://electrum.org/#download";
    changelog = "https://github.com/spesmilo/electrum/blob/master/RELEASE-NOTES";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      joachifm
      np
      prusnak
      chewblacka
    ];
    mainProgram = "electrum";
  };
}
