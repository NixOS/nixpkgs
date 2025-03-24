{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kio,
  ktextwidgets,
  kwidgetsaddons,
  pimcommon,
}:

mkDerivation {
  pname = "libgravatar";
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
  propagatedBuildInputs = [
    kconfig
    kio
    ktextwidgets
    kwidgetsaddons
    pimcommon
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
