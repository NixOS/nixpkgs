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
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "Electron-Cash";
    repo = "Electron-Cash";
    rev = "refs/tags/${version}";
    sha256 = "sha256-4cKlDJRFHt+FQ1ycO1Jz/stdhj9omiLu2G2vk7WmsIc=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "(share_dir" "(\"share\""
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace-fail "Exec=electron-cash" "Exec=$out/bin/electron-cash"
  '';

  # If secp256k1 wasn't added to the library path, the following warning is given:
  #
  #   Electron Cash was unable to find the secp256k1 library on this system.
  #   Elliptic curve cryptography operations will be performed in slow
  #   Python-only mode.
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--prefix" "LD_LIBRARY_PATH" ":" "${secp256k1}/lib"
    )
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electron-cash help >/dev/null
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
