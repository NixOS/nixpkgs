{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  akonadi-search,
  kconfig,
  kservice,
  kio,
  mailcommon,
  mailimporter,
  messagelib,
}:

mkDerivation {
  pname = "mbox-importer";
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
    akonadi-search
    kconfig
    kservice
    kio
    mailcommon
    mailimporter
    messagelib
  ];
}
