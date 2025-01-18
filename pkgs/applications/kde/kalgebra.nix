{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  analitza,
  ki18n,
  kinit,
  kirigami2,
  kconfigwidgets,
  kwidgetsaddons,
  kio,
  kxmlgui,
  qtwebengine,
  plasma-framework,
}:

mkDerivation {
  pname = "kalgebra";

  outputs = [
    "out"
    "dev"
  ];

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

  meta = with lib; {
    homepage = "https://apps.kde.org/kalgebra/";
    description = "2D and 3D Graph Calculator";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ninjafb ];
  };
}
