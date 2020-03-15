{ lib, fetchFromGitHub, python3Packages, qtbase, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "electron-cash";
  version = "4.0.11";

  src = fetchFromGitHub {
    owner = "Electron-Cash";
    repo = "Electron-Cash";
    rev = version;
    sha256 = "1k4zbaj0g8bgk1l5vrb835a8bqfay2707bcb4ql2vx4igcwpb680";
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

  postFixup = ''
    wrapQtApp $out/bin/electron-cash
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
