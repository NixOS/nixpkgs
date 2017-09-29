{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kio
}:

mkDerivation {
  name = "syndication";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kio ];
  outputs = [ "out" "dev" ];
}
