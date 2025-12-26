{
  stdenv,
  lib,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "savvycan";
  version = "220";

  src = fetchFromGitHub {
    owner = "collin80";
    repo = "SavvyCAN";
    rev = "V${version}";
    hash = "sha256-Du6Pc0JePdJNwBaWKKjTMWOmKCnk6Azojh8IJ7I+ngY=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtserialbus
    qt5.qtserialport
    qt5.qtdeclarative
  ];

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/SavvyCAN.app $out/Applications
    ln -s $out/Applications/SavvyCAN.app/Contents/MacOS/SavvyCAN $out/bin/SavvyCAN
  '';

  meta = {
    description = "QT based cross platform canbus tool";
    homepage = "https://savvycan.com/";
    changelog = "https://github.com/collin80/SavvyCAN/releases/tag/${version}";
    maintainers = with lib.maintainers; [ simoneruffini ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "SavvyCAN";
    longDescription = ''
      SavvyCAN is a cross platform QT based C++ program. It is a CAN bus reverse
      engineering and capture tool. It was originally written to utilize EVTV
      hardware such as the EVTVDue and CANDue hardware. It has since expanded to be
      able to use any socketCAN compatible device as well as the Macchina M2 and
      Teensy 3.x boards. SavvyCAN can use any CAN interface supported by QT's
      SerialBus system (PeakCAN, Vector, SocketCAN, J2534, etc) It can capture and
      send to multiple buses and CAN capture devices at once. It has many functions
      specifically meant for reverse engineering data found on the CAN bus:
      - Ability to capture even very highly loaded buses
      - Ability to connect to many dongles simultaneously
      - Scan captured traffic for data that looks coherent
      - Show ASCII of captured data to find things like VIN numbers and traffic to
        and from the radio
      - Graph data found on the bus
      - Load and Save many different file formats common to CAN capture tools (Vector
        captures, Microchip, CANDo, PCAN, and many more)
      - Load and Save DBC files. DBC files are used to store definitions for how data
        are formatted on the bus. You can turn the raw data into things like a RPM,
        odometer readings, and more.
      - UDS scanning and decoding
      - Scripting interface to be able to expand the scope of the software
      - Best of all, it's free and open source. Don't like something about it? Change
        it!
    '';
  };
}
