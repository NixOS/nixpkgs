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
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs ki18n qtbase ];
  outputs = [ "out" "dev" ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
