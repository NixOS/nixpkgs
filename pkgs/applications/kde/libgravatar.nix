{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kconfig, kio, ktextwidgets, kwidgetsaddons, pimcommon
}:

mkDerivation {
  pname = "libgravatar";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kconfig kio ktextwidgets kwidgetsaddons pimcommon
  ];
  outputs = [ "out" "dev" ];
}
