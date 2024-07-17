{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  calendarsupport,
  kcalutils,
  kdiagram,
  libkdepim,
  qtbase,
  qttools,
  kholidays,
}:

mkDerivation {
  pname = "eventviews";
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
    calendarsupport
    kcalutils
    kdiagram
    libkdepim
    qtbase
    qttools
    kholidays
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
