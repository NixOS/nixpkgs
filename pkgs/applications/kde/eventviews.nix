{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, calendarsupport, kcalutils,
  kdiagram, libkdepim, qtbase, qttools, kholidays
}:

mkDerivation {
  name = "eventviews";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi calendarsupport kcalutils kdiagram
    libkdepim qtbase qttools kholidays
  ];
  outputs = [ "out" "dev" ];
}
