{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kparts, ktexteditor, kwidgetsaddons, libkomparediff2
}:

mkDerivation {
  name = "kompare";
  meta = { license = with lib.licenses; [ gpl2 ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kparts ktexteditor kwidgetsaddons libkomparediff2
  ];
}
