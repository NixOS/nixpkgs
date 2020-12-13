{
  mkDerivation, lib, extra-cmake-modules
, qtbase, karchive, shared-mime-info
}:

mkDerivation {
  name = "kpkpass";
  meta = {
    license = with lib.licenses; [ lgpl21 ];
    maintainers = [ lib.maintainers.bkchr ];
    broken = lib.versionOlder qtbase.version "5.15";
  };
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [ qtbase karchive ];
  outputs = [ "out" "dev" ];
}
