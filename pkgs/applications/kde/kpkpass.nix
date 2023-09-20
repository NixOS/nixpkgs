{
  mkDerivation, lib, extra-cmake-modules
, qtbase, karchive, shared-mime-info
}:

mkDerivation {
  pname = "kpkpass";
  meta = {
    license = with lib.licenses; [ lgpl21 ];
    maintainers = [ lib.maintainers.bkchr ];
  };
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [ qtbase karchive ];
  outputs = [ "out" "dev" ];
}
