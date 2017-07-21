{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kparts, qtsvg, qtxmlpatterns, ktexteditor, boost,
  karchive, kcrash
}:

mkDerivation {
  name = "kig";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ raskin ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ boost ];
  propagatedBuildInputs = [
    kparts qtsvg qtxmlpatterns ktexteditor karchive kcrash
  ];
}

