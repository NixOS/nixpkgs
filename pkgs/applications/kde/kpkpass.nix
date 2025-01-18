{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  karchive,
  shared-mime-info,
}:

mkDerivation {
  pname = "kpkpass";
  meta = with lib; {
    license = with licenses; [ lgpl21 ];
    maintainers = [ maintainers.bkchr ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    qtbase
    karchive
  ];
  outputs = [
    "out"
    "dev"
  ];
}
