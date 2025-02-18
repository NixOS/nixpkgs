{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  qt5,
  secp256k1,
}:

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "Electron-Cash";
    repo = "Electron-Cash";
    tag = version;
    sha256 = "sha256-hqaPxetS6JONvlRMjNonXUGFpdmnuadD00gcPzY07x0=";
  };

  build-system = with python3Packages; [
    cython
  ];

  propagatedBuildInputs = with python3Packages; [
    # requirements
    pyaes
    ecdsa
    requests
    qrcode
    protobuf
    jsonrpclib-pelix
    pysocks
    qdarkstyle
    python-dateutil
    stem
    certifi
    pathvalidate
    dnspython
    bitcoinrpc

    # requirements-binaries
    pyqt5
    psutil
    pycryptodomex
    cryptography
    zxing-cpp

    # requirements-hw
    trezor
    keepkey
    btchip-python
    hidapi
    pyopenssl
    pyscard
    pysatochip
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  buildInputs = [ ] ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  # If secp256k1 wasn't added to the library path, the following warning is given:
  #
  #   Electron Cash was unable to find the secp256k1 library on this system.
  #   Elliptic curve cryptography operations will be performed in slow
  #   Python-only mode.
  #
  # Upstream hardcoded `libsecp256k1.so.0` where we provides
  # `libsecp256k1.so.5`. The only breaking change is the removal of two
  # functions which seem not used by electron-cash.
  # See: <https://github.com/Electron-Cash/Electron-Cash/issues/3009>
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "(share_dir" '("share"'
    substituteInPlace electroncash/secp256k1.py \
      --replace-fail "libsecp256k1.so.0" "${secp256k1}/lib/libsecp256k1.so.5"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    output="$($out/bin/electron-cash help 2>&1)"
    if [[ "$output" == *"failed to load"* ]]; then
      echo "$output"
      echo "Forbidden text detected: failed to load"
      exit 1
    fi
  '';

  meta = {
    description = "Bitcoin Cash SPV Wallet";
    mainProgram = "electron-cash";
    longDescription = ''
      An easy-to-use Bitcoin Cash client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://www.electroncash.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      lassulus
      nyanloutre
      oxalica
    ];
    license = lib.licenses.mit;
  };
}
