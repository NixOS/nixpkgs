{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  autoPatchelfHook,
  cmake,
  pkg-config,
  boost,
  curl,
  libzip,
  miniupnpc,
  openssl,
  qrencode,
  qtbase,
  qttools,
  secp256k1,
  withGui ? true,
  withUpnp ? false,
}:
stdenv.mkDerivation rec {
  pname = "gridcoin-research";
  version = "5.4.7.0";

  src = fetchFromGitHub {
    owner = "gridcoin-community";
    repo = "Gridcoin-Research";
    rev = "${version}";
    sha256 = "sha256-wdXah7QnWohGAtC98exPSkhg5F3BaBOiFs6bklFxD7E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
  ] ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs =
    [
      boost
      curl
      libzip
      openssl
      secp256k1
    ]
    ++ lib.optionals withGui [
      qrencode
      qtbase
      qttools
    ]
    ++ lib.optionals withUpnp [ miniupnpc ];

  cmakeFlags =
    [ "-DENABLE_TESTS=OFF" ]
    ++ lib.optionals (!withGui) [
      "-DENABLE_GUI=OFF"
      "-DENABLE_QRENCODE=OFF"
    ]
    ++ lib.optionals withGui [
      "-DENABLE_GUI=ON"
      "-DENABLE_QRENCODE=ON"
    ]
    ++ lib.optionals withUpnp [
      "-DENABLE_UPNP=ON"
      "-DDEFAULT_UPNP=ON"
    ];

  patches = [ ./0001-fix-install-systemd.patch ];

  meta = with lib; {
    description = "A POS-based cryptocurrency that rewards users for participating on the BOINC network";
    longDescription = ''
      A POS-based cryptocurrency that rewards users for participating on the BOINC network,
      using peer-to-peer technology to operate with no central authority - managing transactions,
      issuing money and contributing to scientific research are carried out collectively by the network
    '';
    homepage = "https://gridcoin.us/";
    license = licenses.mit;
    maintainers = with maintainers; [ gigglesquid ];
    platforms = platforms.linux;
  };
}
