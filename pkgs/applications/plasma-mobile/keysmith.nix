{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kdbusaddons
, ki18n
, kirigami2
, kwindowsystem
, libsodium
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "keysmith";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kdbusaddons
    ki18n
    kirigami2
    kwindowsystem
    libsodium
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "OTP client for Plasma Mobile and Desktop";
    license = licenses.gpl3;
    homepage = "https://github.com/KDE/keysmith";
    maintainers = with maintainers; [ samueldr shamilton ];
    platforms = platforms.linux;
  };
}
