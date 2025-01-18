{
  mkDerivation,
  lib,
  exiv2,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation {
  pname = "libkexiv2";
  meta = with lib; {
    license = with licenses; [
      gpl2
      lgpl21
      bsd3
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ exiv2 ];
  outputs = [
    "out"
    "dev"
  ];
}
