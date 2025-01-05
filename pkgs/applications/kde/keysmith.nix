{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,

  kdbusaddons,
  ki18n,
  kirigami2,
  kirigami-addons,
  kwindowsystem,
  libsodium,
  qtquickcontrols2,
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
    kirigami-addons
    kwindowsystem
    libsodium
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "OTP client for Plasma Mobile and Desktop";
    mainProgram = "keysmith";
    license = licenses.gpl3;
    homepage = "https://github.com/KDE/keysmith";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
