{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, analitza
, ki18n
, kinit
, kirigami2
, kconfigwidgets
, kwidgetsaddons
, kio
, kxmlgui
, qtwebengine
, plasma-framework
}:

mkDerivation {
  pname = "kalgebra";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    ki18n
    analitza
    kinit
    kirigami2
    kconfigwidgets
    kwidgetsaddons
    kio
    kxmlgui
    qtwebengine
    plasma-framework
  ];

  meta = {
    homepage = "https://apps.kde.org/kalgebra/";
    description = "A 2D and 3D Graph Calculator";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ ninjafb ];
  };
}
