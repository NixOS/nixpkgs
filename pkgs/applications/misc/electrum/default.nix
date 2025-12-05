{
  lib,
  stdenv,
  fetchurl,
  protobuf,
  wrapQtAppsHook,
  python3,
  zbar,
  enableQt ? true,
  enablePythonEcdsa ? false,
  callPackage,
  qtwayland,
}:

let
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
  version = "4.6.2";
  pyproject = true;

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    hash = "sha256-ZrwzAeeMNrs6KzLGDg5oBF7E+GGLYCVczO6R18TKRuE=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    protobuf
    python3.pkgs.pythonRelaxDepsHook
  ]
  ++ lib.optionals enableQt [
    wrapQtAppsHook
  ];
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
      electrum-aionostr
      electrum-ecc
      # plugins
      ledger-bitcoin
      cbor2
      pyserial
    ]
    ++ lib.optionals enablePythonEcdsa [
      # enablePythonEcdsa gates plugins known to pull in python-ecdsa, which we
      # avoid by default due to CVE-2024-23342.
      ckcc-protocol
      keepkey
      trezor
      bitbox02
    ]
    ++ lib.optionals enableQt [
      pyqt6
      qdarkstyle
    ];

  pythonRelaxDeps = [
    "attrs"
    "dnspython"
  ];

  pythonRemoveDeps = [
    "protobuf"
  ];

  checkInputs =
    with python3.pkgs;
    lib.optionals enableQt [
      pyqt6
    ];
  disabledTestPaths = lib.optionals (!enableQt) [
    "tests/test_qml_types.py"
  ];

  postPatch = ''
    # Upstream tarball omits regenerated protobuf bindings in some releases.
    protoc --python_out=. electrum/paymentrequest.proto
  ''
  + (
    if enableQt then
      ''
        substituteInPlace ./electrum/qrscanner.py \
          --replace-fail ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
      ''
    else
      ''
        sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
      ''
  );

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
  ];

  enabledTestPaths = [ "tests" ];

  # avoid homeless-shelter error in tests
  preCheck = ''
    export PYTHONPATH=${python3.pkgs.protobuf}/${python3.sitePackages}:$PYTHONPATH
    export HOME="$(mktemp -d)"
  '';

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
    ];
    mainProgram = "electrum";
  };
}
