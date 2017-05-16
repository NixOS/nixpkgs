{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kparts, qtsvg, qtxmlpatterns, ktexteditor, boost
}:

mkDerivation {
  name = "kig";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ raskin ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  buildInputs = [
    kparts qtsvg qtxmlpatterns ktexteditor boost
  ];
}

