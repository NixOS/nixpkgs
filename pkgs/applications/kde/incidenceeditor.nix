{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  akonadi-mime,
  calendarsupport,
  eventviews,
  kdiagram,
  kldap,
  kmime,
  pimcommon,
  qtbase,
}:

mkDerivation {
  pname = "incidenceeditor";
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
    calendarsupport
    eventviews
    kdiagram
    kldap
    kmime
    pimcommon
    qtbase
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
