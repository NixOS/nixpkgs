{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  boost,
  gpgme,
  kcmutils,
  kdbusaddons,
  kiconthemes,
  kitemmodels,
  kmime,
  knotifications,
  kwindowsystem,
  kxmlgui,
  libkleo,
  kcrash,
  kpipewire,
}:

mkDerivation {
  pname = "kleopatra";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    boost
    gpgme
    kcmutils
    kdbusaddons
    kiconthemes
    kitemmodels
    kmime
    knotifications
    kwindowsystem
    kxmlgui
    libkleo
    kcrash
    kpipewire
  ];

  meta = {
    homepage = "https://apps.kde.org/kleopatra/";
    description = "Certificate manager and unified crypto GUI";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = kdepimTeam;
  };
}
