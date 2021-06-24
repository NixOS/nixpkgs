{ lib, fetchFromGitHub, python3Packages, qtbase, fetchpatch, wrapQtAppsHook
, secp256k1 }:

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "4.2.4";

  src = fetchFromGitHub {
    owner = "Electron-Cash";
    repo = "Electron-Cash";
    rev = version;
    sha256 = "sha256-hiOS0cTaPqllb31p+6nU4GYvw/E1Hdn8yd3sppzGkqg=";
  };

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

    # requirements-binaries
    pyqt5
    psutil
    pycryptodomex
    cryptography

    # requirements-hw
    cython
    trezor
    keepkey
    btchip
    hidapi
    pyscard
    pysatochip
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "qdarkstyle==2.6.8" "qdarkstyle<3"

    substituteInPlace setup.py \
      --replace "(share_dir" "(\"share\""
  '';

  checkInputs = with python3Packages; [ pytest ];

  checkPhase = ''
    unset HOME
    pytest electroncash/tests
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/electron-cash.desktop \
      --replace "Exec=electron-cash" "Exec=$out/bin/electron-cash"
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

  meta = with lib; {
    description = "A Bitcoin Cash SPV Wallet";
    longDescription = ''
      An easy-to-use Bitcoin Cash client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://www.electroncash.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus nyanloutre oxalica ];
    license = licenses.mit;
  };
}
