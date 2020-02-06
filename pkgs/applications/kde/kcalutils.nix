{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, kcalendarcore, kconfig, kontactinterface, kcoreaddons, kdelibs4support,
  kidentitymanagement, kpimtextedit,
}:

mkDerivation {
  name = "kcalutils";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcalendarcore kconfig kontactinterface kcoreaddons kdelibs4support
    kidentitymanagement kpimtextedit
  ];
  outputs = [ "out" "dev" ];
}
