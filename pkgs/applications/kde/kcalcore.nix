{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kdelibs4support, libical
}:

mkDerivation {
  name = "kcalcore";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kdelibs4support libical ];
  outputs = [ "out" "dev" ];
}
