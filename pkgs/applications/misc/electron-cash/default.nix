{ lib, fetchFromGitHub, python3Packages, qtbase, wrapQtAppsHook, secp256k1 }:

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "4.0.14";

  src = fetchFromGitHub {
    owner = "Electron-Cash";
    repo = "Electron-Cash";
    rev = version;
    sha256 = "1dp7cj1185h6xfz6jzh0iq58zvg3wq9hl96bkgxkf5h4ygni2vm6";
  };

  propagatedBuildInputs = with python3Packages; [
    dnspython
    ecdsa
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    pyaes
    pycrypto
    pyqt5
    pysocks
    qrcode
    requests
    tlslite-ng
    qdarkstyle
    stem

    # plugins
    keepkey
    trezor
    btchip
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "qdarkstyle==2.6.8" "qdarkstyle<3"

    substituteInPlace setup.py \
      --replace "(share_dir" "(\"share\""
  '';

  checkInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    unset HOME
    pytest lib/tests
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
  postFixup = ''
    wrapQtApp $out/bin/electron-cash \
      --prefix LD_LIBRARY_PATH : ${secp256k1}/lib
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
    homepage = https://www.electroncash.org/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus nyanloutre ];
    license = licenses.mit;
  };
}
