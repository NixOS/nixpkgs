{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  shared-mime-info,
  akonadi,
  kdbusaddons,
  ki18n,
  kio,
  kitemmodels,
  kmime,
}:

mkDerivation {
  pname = "akonadi-mime";
  meta = {
    license = with lib.licenses; [
      gpl2
      lgpl21
    ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    akonadi
    kdbusaddons
    ki18n
    kio
    kitemmodels
    kmime
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
