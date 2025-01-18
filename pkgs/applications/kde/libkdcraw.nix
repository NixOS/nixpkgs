{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libraw,
  qtbase,
}:

mkDerivation {
  pname = "libkdcraw";
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
  propagatedBuildInputs = [ libraw ];
  outputs = [
    "out"
    "dev"
  ];
}
