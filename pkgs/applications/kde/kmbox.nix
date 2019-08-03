{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kmime, qtbase, kcodecs
}:

mkDerivation {
  name = "kmbox";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kmime qtbase kcodecs ];
  outputs = [ "out" "dev" ];
}
