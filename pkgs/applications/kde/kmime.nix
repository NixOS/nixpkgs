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
  nativeBuildInputs = [ extra-cmake-modules ki18n ];
  buildInputs = [ kcodecs qtbase ];
  outputs = [ "out" "dev" ];
}
