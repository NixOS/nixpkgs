{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  akonadi-mime,
  karchive,
  kcodecs,
  kcompletion,
  kconfigwidgets,
  kdbusaddons,
  kdesignerplugin,
  kiconthemes,
  kio,
  kitemmodels,
  kldap,
  kmailtransport,
  kwindowsystem,
  mailimporter,
  messagelib,
  phonon,
  libkdepim,
}:

mkDerivation {
  pname = "mailcommon";
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
    akonadi-mime
    karchive
    kcodecs
    kcompletion
    kconfigwidgets
    kdbusaddons
    kdesignerplugin
    kiconthemes
    kio
    kitemmodels
    kldap
    kmailtransport
    kwindowsystem
    mailimporter
    messagelib
    phonon
    libkdepim
  ];
  outputs = [
    "out"
    "dev"
  ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
