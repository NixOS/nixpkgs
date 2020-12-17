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
, qtgraphicaleffects
, qtmultimedia
, qtx11extras
, sshfs
}:

mkDerivation {
  name = "kdeconnect-kde";

  patches = [
    # https://invent.kde.org/network/kdeconnect-kde/-/merge_requests/328
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/6101ef3ad07d865958d58a3d2736f5536f1c5719.diff";
      sha256 = "17mr7k13226vzcgxlmfs6q2mdc5j7vwp4iri9apmh6xlf6r591ac";
    })
  ];

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
    qtgraphicaleffects
    qtmultimedia
    qtx11extras
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
