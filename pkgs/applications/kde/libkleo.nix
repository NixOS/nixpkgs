{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  boost,
  qgpgme,
  kcodecs,
  kcompletion,
  kconfig,
  kcoreaddons,
  ki18n,
  kitemmodels,
  kpimtextedit,
  kwidgetsaddons,
  kwindowsystem,
}:

mkDerivation {
  pname = "libkleo";
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
    boost
    kcodecs
    kcompletion
    kconfig
    kcoreaddons
    ki18n
    kitemmodels
    kpimtextedit
    kwidgetsaddons
    kwindowsystem
  ];
  propagatedBuildInputs = [ qgpgme ];
  outputs = [
    "out"
    "dev"
  ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
