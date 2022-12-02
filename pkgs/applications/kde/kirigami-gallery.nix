{ mkDerivation
, lib
, kirigami2
, extra-cmake-modules
, kitemmodels
, qtgraphicaleffects
, qtquickcontrols2
, qttools
, qtbase
}:

mkDerivation rec {
  pname = "kirigami-gallery";

  nativeBuildInputs = [ extra-cmake-modules qttools ];

  buildInputs = [
    qtgraphicaleffects
    qtquickcontrols2
    kirigami2
    kitemmodels
  ];

  meta = with lib; {
    homepage = "https://apps.kde.org/kirigami2.gallery/";
    description = "View examples of Kirigami components";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ shadowrz ];
    broken = versionOlder qtbase.version "5.15";
  };
}
