{
  mkDerivation,
  lib,
  extra-cmake-modules,
  karchive,
  kcalendarcore,
  kcontacts,
  kdbusaddons,
  kfilemetadata,
  kholidays,
  kio,
  kirigami-addons,
  kitemmodels,
  kitinerary,
  kmime,
  knotifications,
  kosmindoormap,
  kpkpass,
  kpublictransport,
  kunitconversion,
  libquotient,
  networkmanager-qt,
  prison,
  qqc2-desktop-style,
  qtpositioning,
  qtquickcontrols2,
  shared-mime-info,
}:

mkDerivation {
  pname = "itinerary";
  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info # for update-mime-database
  ];

  buildInputs = [
    karchive
    kcalendarcore
    kcontacts
    kdbusaddons
    kfilemetadata
    kholidays
    kio
    kirigami-addons
    kitemmodels
    kitinerary
    kmime
    knotifications
    kosmindoormap
    kpkpass
    kpublictransport
    kunitconversion
    libquotient
    networkmanager-qt
    prison
    qqc2-desktop-style
    qtpositioning
    qtquickcontrols2
  ];

  meta.license = with lib.licenses; [
    asl20
    bsd3
    cc0
    lgpl2Plus
  ];
}
