{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, kdelibs4support
, libkexiv2
}:

mkDerivation {
  name = "kolourpaint";
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ kdelibs4support libkexiv2 ];
  meta = {
    maintainers = [ lib.maintainers.fridh ];
    license = with lib.licenses; [ gpl2 ];
  };
}
