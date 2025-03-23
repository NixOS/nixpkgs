{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  cyrus_sasl,
  kcoreaddons,
  ki18n,
  kio,
  kmime,
  kitemmodels,
}:

mkDerivation {
  pname = "kimap";
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
    ki18n
    kio
  ];
  propagatedBuildInputs = [
    cyrus_sasl
    kcoreaddons
    kmime
    kitemmodels
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
