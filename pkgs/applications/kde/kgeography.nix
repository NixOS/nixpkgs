{ mkDerivation, lib
, cmake, extra-cmake-modules, qtbase
, kconfigwidgets, kxmlgui, kcrash, kdoctools
, kitemviews
}:

mkDerivation {
  name = "kgeography";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.globin ];
  };
  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qtbase kconfigwidgets kxmlgui kcrash kdoctools kitemviews ];
}
