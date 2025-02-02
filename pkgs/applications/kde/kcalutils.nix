{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, kcalendarcore, kconfig, kontactinterface, kcoreaddons,
  kidentitymanagement, kpimtextedit,
}:

mkDerivation {
  pname = "kcalutils";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcalendarcore kconfig kontactinterface kcoreaddons
    kidentitymanagement kpimtextedit
  ];
  outputs = [ "out" "dev" ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
