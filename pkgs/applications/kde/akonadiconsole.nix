{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  akonadi-contacts,
  calendarsupport,
  kcalendarcore,
  kcompletion,
  kconfigwidgets,
  kcontacts,
  kdbusaddons,
  kitemmodels,
  kpimtextedit,
  libkdepim,
  ktextwidgets,
  kxmlgui,
  messagelib,
  qtbase,
  akonadi-search,
  xapian,
}:

mkDerivation {
  pname = "akonadiconsole";
  meta = {
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    akonadi
    akonadi-contacts
    calendarsupport
    kcalendarcore
    kcompletion
    kconfigwidgets
    kcontacts
    kdbusaddons
    kitemmodels
    kpimtextedit
    ktextwidgets
    kxmlgui
    messagelib
    qtbase
    libkdepim
    akonadi-search
    xapian
  ];
}
