{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, ki18n,
  kcodecs, qtbase,
}:

mkDerivation {
  name = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = kdepimTeam;
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
