{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, kcalendarcore, kdelibs4support, kholidays, kidentitymanagement,
  kpimtextedit, kcalutils
}:

mkDerivation {
  name = "kalarmcal";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi kcalendarcore kdelibs4support kholidays kidentitymanagement kpimtextedit kcalutils
  ];
  outputs = [ "out" "dev" ];
}
