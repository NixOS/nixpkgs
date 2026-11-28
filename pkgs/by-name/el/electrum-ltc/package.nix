{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  gettext,
  python3Packages,
  zxing-cpp,
  enableQt ? true,
  qt6,
  enablePythonEcdsa ? false,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

let
  version = "4.8.3.1";

  mwebdLibName = if stdenv.hostPlatform.isDarwin then "libmwebd.0.dylib" else "libmwebd.so.0";

  src = fetchFromGitHub {
    owner = "ltc-electrum";
    repo = "electrum-ltc";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-cXzBUlfjWqVfwQJ1xQE2eewPOb8Qd1YbMiFHR95ka4Y=";
  };

  mwebd = buildGoModule {
    pname = "libmwebd";
    inherit src version;

    modRoot = "contrib/mwebd";
    # go mod vendor drops the vendored secp256k1 C sources
    proxyVendor = true;
    vendorHash = "sha256-LXuTA20Nk6rC0uFM/BD9qtobdPRhnOU1/HPA21zDyyQ=";

    buildPhase = ''
      runHook preBuild
      go build -buildmode=c-shared -ldflags="-buildid=" -o ${mwebdLibName} .
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 ${mwebdLibName} $out/lib/${mwebdLibName}
      runHook postInstall
    '';

    doCheck = false;
  };
in

python3Packages.buildPythonApplication {
  pname = "electrum-ltc";
  inherit version src;
  pyproject = true;
  __structuredAttrs = true;

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    gettext
    python3Packages.pythonRelaxDepsHook
  ]
  ++ lib.optionals enableQt [ qt6.wrapQtAppsHook ];

  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && enableQt) qt6.qtwayland;

  dependencies =
    with python3Packages;
    [
      aiohttp
      aiohttp-socks
      aiorpcx
      attrs
      bitstring
      certifi
      cryptography
      dnspython
      electrum-aionostr
      electrum-ecc
      grpcio
      jsonpatch
      jsonrpclib-pelix
      pbkdf2
      protobuf
      pysocks
      qrcode
      requests
      # plugins
      cbor2
      ledger-bitcoin
      pyserial
      trezor
    ]
    ++ lib.optionals enablePythonEcdsa [
      # these plugins depend on python-ecdsa, which is affected by CVE-2024-23342
      bitbox02
      ckcc-protocol
      keepkey
    ]
    ++ lib.optionals enableQt [
      matplotlib
      pyqt6
      qdarkstyle
    ];

  pythonRelaxDeps = [ "dnspython" ];

  postPatch = ''
    install -Dm755 ${mwebd}/lib/${mwebdLibName} ./electrum/${mwebdLibName}

    # the locale files are a submodule that only ships .po sources
    patchShebangs contrib/locale
    substituteInPlace contrib/locale/build_locale.sh \
      --replace-fail "which msgfmt" "command -v msgfmt"
    bash contrib/locale/build_locale.sh electrum/locale/locale electrum/locale/locale
  ''
  + lib.optionalString enableQt ''
    substituteInPlace ./electrum/qrreader/zxing.py \
      --replace-fail "LIBNAMES = (" "LIBNAMES = ('${lib.getLib zxing-cpp}/lib/libZXing${stdenv.hostPlatform.extensions.sharedLibrary}',"
  ''
  + lib.optionalString (!enableQt) ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '';

  postInstall = ''
    install -Dm755 ${mwebd}/lib/${mwebdLibName} $out/${python3Packages.python.sitePackages}/electrum/${mwebdLibName}
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/applications/electrum-ltc.desktop \
      --replace-fail "Exec=electrum-ltc %u" "Exec=$out/bin/electrum-ltc %u" \
      --replace-fail "Exec=electrum-ltc --testnet %u" "Exec=$out/bin/electrum-ltc --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-ltc
  '';

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs =
    with python3Packages;
    [
      pyaes
      pycryptodomex
      pytestCheckHook
    ]
    ++ [
      # avoid homeless-shelter error in tests
      writableTmpDirAsHomeHook
    ];

  # The rest of the fork's test suite still uses Bitcoin addresses and units
  # and fails on Litecoin.
  enabledTestPaths = [
    "tests/plugins/test_revealer.py"
    "tests/test_address_synchronizer.py"
    "tests/test_blockchain.py"
    "tests/test_callbackmgr.py"
    "tests/test_contacts.py"
    "tests/test_fee_policy.py"
    "tests/test_i18n.py"
    "tests/test_jsondb.py"
    "tests/test_lnhtlc.py"
    "tests/test_lnpeermgr.py"
    "tests/test_lnrouter.py"
    "tests/test_lntransport.py"
    "tests/test_lnurl.py"
  ];

  postCheck = ''
    $out/bin/electrum-ltc help >/dev/null
    ${python3Packages.python.interpreter} -c 'from electrum.mwebd import scrypt; scrypt(b"test")'
  ''
  + lib.optionalString enableQt ''
    ${python3Packages.python.interpreter} -c 'from electrum.qrreader import get_qr_reader; get_qr_reader()'
  '';

  meta = {
    description = "Lightweight Litecoin client";
    longDescription = ''
      Electrum-LTC is a simple, but powerful Litecoin wallet. A unique secret
      phrase (or "seed") leaves intruders stranded and your peace of mind
      intact. Keep it on paper, or in your head... and never worry about losing
      your litecoins to theft or hardware failure.
    '';
    homepage = "https://ltc-electrum.github.io/";
    downloadPage = "https://github.com/ltc-electrum/electrum-ltc/releases";
    changelog = "https://github.com/ltc-electrum/electrum-ltc/blob/master/RELEASE-NOTES";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "electrum-ltc";
    maintainers = with lib.maintainers; [
      bbjubjub
      surfaceflinger
    ];
  };
}
