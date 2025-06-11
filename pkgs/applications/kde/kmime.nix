{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  ki18n,
  kcodecs,
  qtbase,
}:

mkDerivation {
  pname = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcodecs
    ki18n
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
