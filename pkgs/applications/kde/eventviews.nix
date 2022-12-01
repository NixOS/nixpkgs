{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, calendarsupport, kcalutils,
  kdiagram, libkdepim, qtbase, qttools, kholidays
}:

mkDerivation {
  pname = "eventviews";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi calendarsupport kcalutils kdiagram
    libkdepim qtbase qttools kholidays
  ];
  outputs = [ "out" "dev" ];
}
