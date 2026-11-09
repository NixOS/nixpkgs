{
  lib,
  stdenv,
  fetchurl,
  python3,
  zxing-cpp,
  enableQt ? true,
  qt5,
  enablePythonEcdsa ? false,
  callPackage,

  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "electrum";
  version = "4.8.3";
  pyproject = true;

  src = fetchurl {
    url = "https://download.electrum.org/${finalAttrs.version}/Electrum-${finalAttrs.version}.tar.gz";
    hash = "sha256-30H6guV59yCjhZv/neCd2Yu5MHmwH6KXO3P9vb/ecog=";
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ]
  ++ lib.optionals enableQt [
    qt5.wrapQtAppsHook
  ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && enableQt) qt5.qtwayland;

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
      pbkdf2
      protobuf
      pysocks
      qrcode
      requests
      certifi
      jsonpatch
      electrum-aionostr
      electrum-ecc
      # plugins
      ledger-bitcoin
      cbor2
      pyserial
      trezor
    ]
    ++ lib.optionals enablePythonEcdsa [
      # enablePythonEcdsa gates plugins known to pull in python-ecdsa, which we
      # avoid by default due to CVE-2024-23342.
      ckcc-protocol
      keepkey
      bitbox02
    ]
    ++ lib.optionals enableQt [
      matplotlib
      pyqt6
      qdarkstyle
    ];

  pythonRelaxDeps = [
    "attrs"
    "certifi"
    "dnspython"
  ];

  pythonRemoveDeps = [
    "protobuf"
  ];

  checkInputs = lib.optionals enableQt [
    python3.pkgs.pyqt6
  ];
  disabledTestPaths = lib.optionals (!enableQt) [
    "tests/qml"
  ];

  postPatch =
    if enableQt then
      ''
        substituteInPlace ./electrum/qrreader/zxing.py \
          --replace-fail "'libZXing${stdenv.hostPlatform.extensions.sharedLibrary}'" \
            "'${lib.getLib zxing-cpp}/lib/libZXing${stdenv.hostPlatform.extensions.sharedLibrary}'"
      ''
    else
      ''
        sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
      '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/applications/electrum.desktop \
      --replace-fail "Exec=electrum %u" "Exec=$out/bin/electrum %u" \
      --replace-fail "Exec=electrum --testnet %u" "Exec=$out/bin/electrum --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum
  '';

  preFixup = ''
    makeWrapperArgs+=(--prefix PYTHONPATH : ${python3.pkgs.protobuf}/${python3.sitePackages})
  ''
  + lib.optionalString enableQt ''
    qtWrapperArgs+=(--prefix PYTHONPATH : ${python3.pkgs.protobuf}/${python3.sitePackages})
  '';

  nativeCheckInputs = with python3.pkgs; [
    protobuf
    pytestCheckHook
    pyaes
    pycryptodomex

    # avoid homeless-shelter error in tests
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [ "tests" ];

  preCheck = ''
    export PYTHONPATH=${python3.pkgs.protobuf}/${python3.sitePackages}:$PYTHONPATH
  '';

  postCheck = ''
    $out/bin/electrum help >/dev/null
  ''
  + lib.optionalString enableQt ''
    ${python3.interpreter} -c 'from electrum.qrreader import get_qr_reader; get_qr_reader()'
  '';

  passthru.updateScript = callPackage ./update.nix { };

  meta = {
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
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      np
      prusnak
      ryand56
    ];
    mainProgram = "electrum";
  };
})
