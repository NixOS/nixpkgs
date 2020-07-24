{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kcalendarcore, kcalutils, kcontacts, kdelibs4support
}:

mkDerivation {
  name = "ktnef";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcalendarcore kcalutils kcontacts kdelibs4support
  ];
  outputs = [ "out" "dev" ];
}
