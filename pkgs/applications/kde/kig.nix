{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  boost, karchive, kcrash, kiconthemes, kparts, ktexteditor, qtsvg,
  qtxmlpatterns,
}:

mkDerivation {
  name = "kig";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ raskin ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost karchive kcrash kiconthemes kparts ktexteditor qtsvg qtxmlpatterns
  ];
}

