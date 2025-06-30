{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  shared-mime-info,
  akonadi,
  kcmutils,
  kcrash,
  kdbusaddons,
  kidentitymanagement,
  kldap,
  kmailtransport,
  knewstuff,
  knotifications,
  knotifyconfig,
  kparts,
  kross,
  ktexteditor,
  kwallet,
  libkdepim,
  libkleo,
  pimcommon,
  qttools,
}:

mkDerivation {
  pname = "kmail-account-wizard";
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
    shared-mime-info
  ];
  buildInputs = [
    akonadi
    kcmutils
    kcrash
    kdbusaddons
    kidentitymanagement
    kldap
    kmailtransport
    knewstuff
    knotifications
    knotifyconfig
    kparts
    kross
    ktexteditor
    kwallet
    libkdepim
    libkleo
    pimcommon
    qttools
  ];
}
