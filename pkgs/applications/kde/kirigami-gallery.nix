{
  mkDerivation,
  lib,
  kirigami2,
  extra-cmake-modules,
  kitemmodels,
  qtgraphicaleffects,
  qtquickcontrols2,
  qttools,
}:

mkDerivation {
  pname = "kirigami-gallery";

  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];

  buildInputs = [
    qtgraphicaleffects
    qtquickcontrols2
    kirigami2
    kitemmodels
  ];

  meta = {
    homepage = "https://apps.kde.org/kirigami2.gallery/";
    description = "View examples of Kirigami components";
    mainProgram = "kirigami2gallery";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ shadowrz ];
  };
}
