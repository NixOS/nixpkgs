{ mkDerivation
, extra-cmake-modules
, fetchpatch
, kcmutils
, kconfigwidgets
, kdbusaddons
, kdoctools
, ki18n
, kiconthemes
, kio
, kirigami2
, knotifications
, kpeople
, kpeoplevcard
, kwayland
, lib
, libXtst
, libfakekey
, makeWrapper
, pulseaudio-qt
, qca-qt5
, qqc2-desktop-style
, qtgraphicaleffects
, qtmultimedia
, qtquickcontrols2
, qtx11extras
, breeze-icons
, sshfs
, wayland
, wayland-scanner
}:

mkDerivation {
  pname = "kdeconnect-kde";

  buildInputs = [
    kcmutils
    kconfigwidgets
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kirigami2
    knotifications
    kpeople
    kpeoplevcard
    kwayland
    libXtst
    libfakekey
    pulseaudio-qt
    qca-qt5
    qqc2-desktop-style
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols2
    qtx11extras
    wayland
    wayland-scanner
    # otherwise buttons are blank on non-kde
    breeze-icons
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ sshfs ]}"
  ];

  meta = with lib; {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    homepage = "https://community.kde.org/KDEConnect";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ fridh ];
  };
}
