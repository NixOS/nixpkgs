{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  qtwebengine,
  kio,
  kcalendarcore,
  kcontacts,
  cyrus_sasl,
}:

mkDerivation {
  pname = "libkgapi";
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
    qtwebengine
    kio
    kcalendarcore
    kcontacts
    cyrus_sasl
  ];
}
