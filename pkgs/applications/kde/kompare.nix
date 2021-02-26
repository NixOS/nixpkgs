{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, ktexteditor, kwidgetsaddons, libkomparediff2,
  fetchpatch
}:

mkDerivation {
  pname = "kompare";
  meta = { license = with lib.licenses; [ gpl2 ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kiconthemes kparts ktexteditor kwidgetsaddons libkomparediff2
  ];
  outputs = [ "out" "dev" ];
}
