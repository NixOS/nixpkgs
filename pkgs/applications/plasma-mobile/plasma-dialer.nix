{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, callaudiod
, kcontacts
, kcoreaddons
, kdbusaddons
, ki18n
, kio
, kirigami-addons
, kirigami2
, knotifications
, kpeople
, libphonenumber
, libselinux
, libsepol
, modemmanager-qt
, pcre
, plasma-wayland-protocols
, protobuf
, pulseaudio-qt
, qtfeedback
, qtmpris
, qtquickcontrols2
, util-linux
, wayland
, wayland-protocols
}:

mkDerivation rec {
  pname = "plasma-dialer";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    callaudiod
    kcontacts
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    kirigami-addons
    kirigami2
    knotifications
    kpeople
    libphonenumber
    libselinux
    libsepol
    modemmanager-qt
    pcre
    plasma-wayland-protocols
    protobuf # Needed by libphonenumber
    pulseaudio-qt
    qtfeedback
    qtmpris
    qtquickcontrols2
    util-linux
    wayland
    wayland-protocols
  ];

  postPatch = ''
    substituteInPlace plasma-dialer/org.kde.phone.dialer.desktop \
      --replace "/usr/bin/" "$out/bin/"
  '';

  # Plasma gear 22.09 shipped before KWin 5.26 was made available.
  # This feature requires 5.26. Otherwise plasma-dialer segfaults.
  # Note that we may need to keep it disabled until it stops segfaulting outside of KWin.
  cmakeFlags = [
    "-DDIALER_BUILD_SHELL_OVERLAY=OFF"
  ];

  meta = with lib; {
    description = "Dialer for Plasma Mobile";
    mainProgram = "plasmaphonedialer";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-dialer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
