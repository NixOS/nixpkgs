{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kcalendarcore, kcalutils, kcontacts
}:

mkDerivation {
  pname = "ktnef";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcalendarcore kcalutils kcontacts
  ];
  outputs = [ "out" "dev" ];
}
