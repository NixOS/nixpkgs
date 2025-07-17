{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  akonadi-mime,
  kcalendarcore,
  kcmutils,
  kcontacts,
  kcoreaddons,
  kmime,
  krunner,
  qtbase,
  xapian,
}:

mkDerivation {
  pname = "akonadi-search";
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
    kcmutils
    krunner
    xapian
  ];
  propagatedBuildInputs = [
    akonadi
    akonadi-mime
    kcalendarcore
    kcontacts
    kcoreaddons
    kmime
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
