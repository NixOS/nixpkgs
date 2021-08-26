{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, kcalendarcore, kholidays, kidentitymanagement,
  kpimtextedit, kcalutils
}:

mkDerivation {
  pname = "kalarmcal";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi kcalendarcore kholidays kidentitymanagement kpimtextedit kcalutils
  ];
  outputs = [ "out" "dev" ];
}
