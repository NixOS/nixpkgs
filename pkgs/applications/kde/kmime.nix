{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, ki18n,
  kcodecs, qtbase,
}:

mkDerivation {
  pname = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
